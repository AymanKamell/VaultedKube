module "networking" {
  source = "./modules/networking"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr

  # Exactly 2 AZs (high availability)
  azs = var.azs

  # 6 subnets (2 public, 2 private-eks, 2 private-db)
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_eks_subnet_cidrs = var.private_eks_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs

  tags = var.tags

}
