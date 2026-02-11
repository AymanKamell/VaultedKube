variable "project_name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "domain_name" {
  type    = string
  default = null
}

variable "acm_certificate_arn" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
