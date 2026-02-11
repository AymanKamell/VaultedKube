variable "project_name" {
  type = string
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application"
}

variable "create_dns" {
  type    = bool
  default = false
}

variable "wait_for_validation" {
  type    = bool
  default = false
}

variable "cloudfront_domain_name" {
  type    = string
  default = null
}

variable "cloudfront_hosted_zone_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
