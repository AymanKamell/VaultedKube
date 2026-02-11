output "ecr_frontend_url" {
  value = module.eks.ecr_frontend_url
}

output "ecr_backend_url" {
  value = module.eks.ecr_backend_url
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}
