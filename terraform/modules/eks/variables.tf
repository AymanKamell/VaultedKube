variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "region" {
  type        = string
}

variable "vpc_id" {
  type        = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for EKS nodes"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for load balancers"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 4
}

