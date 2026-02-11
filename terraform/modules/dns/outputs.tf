output "alb_certificate_arn" {
  value = var.create_dns ? aws_acm_certificate.alb[0].arn : null
}

output "cloudfront_certificate_arn" {
  value = var.create_dns ? aws_acm_certificate.cloudfront[0].arn : null
}

output "zone_id" {
  value = var.create_dns ? aws_route53_zone.this[0].zone_id : null
}

output "domain_name" {
  value = var.create_dns ? var.domain_name : null
}

output "nameservers" {
  value = var.create_dns ? aws_route53_zone.this[0].name_servers : []
}
