terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

# 1. Route 53 Hosted Zone
resource "aws_route53_zone" "this" {
  count = var.create_dns ? 1 : 0
  name  = var.domain_name
  tags  = var.tags
}

# 2. ACM Certificate for ALB (Regional)
resource "aws_acm_certificate" "alb" {
  count             = var.create_dns ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# 3. ACM Certificate for CloudFront (Global - us-east-1)
resource "aws_acm_certificate" "cloudfront" {
  count             = var.create_dns ? 1 : 0
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# 4. Route 53 Validation Records
resource "aws_route53_record" "validation" {
  for_each = var.create_dns ? {
    for dvo in aws_acm_certificate.alb[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.this[0].zone_id
}

# 5. ACM Validation (ALB)
resource "aws_acm_certificate_validation" "alb" {
  count                   = var.create_dns && var.wait_for_validation ? 1 : 0
  certificate_arn         = aws_acm_certificate.alb[0].arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

# 6. ACM Validation (CloudFront)
resource "aws_acm_certificate_validation" "cloudfront" {
  count                   = var.create_dns && var.wait_for_validation ? 1 : 0
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cloudfront[0].arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

# 7. Route 53 A-Record (Alias to CloudFront)
resource "aws_route53_record" "app" {
  count   = var.create_dns && var.cloudfront_domain_name != null ? 1 : 0
  zone_id = aws_route53_zone.this[0].zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
