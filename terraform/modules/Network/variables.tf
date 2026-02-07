variable "project_name" {
  type        = string
  description = "Name prefix for resources"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "azs" {
  type        = list(string)
  description = "Exactly 2 AZs"
  validation {
    condition     = length(var.azs) == 2
    error_message = "You must provide exactly 2 AZs."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "2 public subnet CIDRs"
  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "You must provide exactly 2 public subnet CIDRs."
  }
}

variable "private_eks_subnet_cidrs" {
  type        = list(string)
  description = "2 private subnet CIDRs for EKS"
  validation {
    condition     = length(var.private_eks_subnet_cidrs) == 2
    error_message = "You must provide exactly 2 private EKS subnet CIDRs."
  }
}

variable "private_db_subnet_cidrs" {
  type        = list(string)
  description = "2 private subnet CIDRs for DB"
  validation {
    condition     = length(var.private_db_subnet_cidrs) == 2
    error_message = "You must provide exactly 2 private DB subnet CIDRs."
  }
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}


variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name for subnet tagging"
  default     = null
}
