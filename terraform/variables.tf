variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project/name prefix for tagging and resource names"
  default     = "vaultedkube"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Exactly 2 AZs for HA"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "2 public subnet CIDRs"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_eks_subnet_cidrs" {
  type        = list(string)
  description = "2 private subnet CIDRs for EKS nodes"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_db_subnet_cidrs" {
  type        = list(string)
  description = "2 private subnet CIDRs for DB"
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}

variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}

