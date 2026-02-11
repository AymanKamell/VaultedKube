variable "project_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Use private DB subnet IDs"
}

variable "eks_nodes_sg_id" {
  type        = string
  description = "EKS nodes security group id"
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

# RDS sizing/options
variable "engine_version" {
  type    = string
  default = "15"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 100
}

variable "multi_az" {
  type    = bool
  default = false
}

# Backups / deletion safety
variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "apply_immediately" {
  type    = bool
  default = true
}

# Encryption (optional KMS)
variable "kms_key_id" {
  type        = string
  default     = null
  description = "Optional CMK ARN for RDS encryption. If null, AWS managed key is used."
}

# CloudWatch logs
variable "cloudwatch_logs_exports" {
  type    = list(string)
  default = ["postgresql", "upgrade"]
}

# Secrets Manager recovery window
variable "secret_recovery_window_days" {
  type    = number
  default = 7
}

