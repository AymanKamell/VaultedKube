locals {
  # Set to true only if you have a registered domain and want to point it to Route 53
  use_custom_domain = true 
  # Set to true ONLY after you've updated your nameservers and the certificate is validated
  ssl_ready         = false
}

module "networking" {
  source = "./modules/networking"

  project_name     = var.project_name
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs

  public_subnet_cidrs      = var.public_subnet_cidrs
  private_eks_subnet_cidrs = var.private_eks_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

  eks_cluster_name = var.eks_cluster_name
  tags             = var.tags
}

module "eks" {
  source = "./modules/eks"

  project_name = var.project_name
  cluster_name = var.eks_cluster_name
  region       = var.region

  vpc_id               = module.networking.vpc_id
  private_subnet_ids   = module.networking.private_eks_subnet_ids
  public_subnet_ids    = module.networking.public_subnet_ids

  tags = var.tags
}

# DNS and SSL Certificates
module "dns" {
  source = "./modules/dns"

  project_name = var.project_name
  domain_name  = "${var.project_name}-ayman.com"
  create_dns   = local.use_custom_domain
  tags         = var.tags

  # Final link: Alias record needs CloudFront details
  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

# Automate Kubernetes Manifests
data "kubectl_path_documents" "k8s_manifests" {
  pattern = "${path.module}/../kubernetes/*/*.yaml"
}

resource "kubectl_manifest" "k8s_apply" {
  for_each  = data.kubectl_path_documents.k8s_manifests.manifests
  yaml_body = each.value

  depends_on = [module.eks, module.rds]
}

# Ingress Resource (moved from YAML)
resource "kubernetes_ingress_v1" "frontend" {
  metadata {
    name      = "frontend-ingress"
    namespace = "final-project"
    annotations = {
      "alb.ingress.kubernetes.io/scheme"       = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/listen-ports" = local.ssl_ready ? "[{\"HTTP\": 80}, {\"HTTPS\": 443}]" : "[{\"HTTP\": 80}]"
      "alb.ingress.kubernetes.io/certificate-arn" = local.ssl_ready ? module.dns.alb_certificate_arn : null
      "alb.ingress.kubernetes.io/ssl-policy"   = local.ssl_ready ? "ELBSecurityPolicy-2016-08" : null
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "frontend"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubectl_manifest.k8s_apply]
}

module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  tags         = var.tags

  vpc_id     = module.networking.vpc_id
  subnet_ids  = module.networking.private_db_subnet_ids

  eks_nodes_sg_id = module.eks.eks_nodes_sg_id

  db_name     = "vaultedkubedb"
  db_username = "vaultedkube"
}

module "cloudfront" {
  source = "./modules/cloudfront"

  project_name = var.project_name
  # Use the Ingress resource output directly to ensure dependency and wait for DNS
  # Using try() because hostname isn't available until the AWS LB Controller provisions the ALB
  alb_dns_name = try(kubernetes_ingress_v1.frontend.status[0].load_balancer[0].ingress[0].hostname, "pending-dns")
  
  # HTTPS additions (conditional)
  domain_name              = local.ssl_ready ? "${var.project_name}-ayman.com" : null
  acm_certificate_arn      = local.ssl_ready ? module.dns.cloudfront_certificate_arn : null
  
  tags         = var.tags
}

output "manifest_count" {
  value = length(data.kubectl_path_documents.k8s_manifests.manifests)
}

output "nameservers" {
  value       = module.dns.nameservers
  description = "The nameservers for your Route 53 Hosted Zone. Update your domain registrar with these."
}

output "cloudfront_url" {
  value = module.cloudfront.cloudfront_domain_name
}
