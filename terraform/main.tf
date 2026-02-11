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

