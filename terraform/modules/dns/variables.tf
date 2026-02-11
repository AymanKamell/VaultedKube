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

variable "tags" {
  type    = map(string)
  default = {}
}
