data "aws_region" "current" {}

resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.project_name}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc-endpoints-sg"
  })
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private_eks[*].id
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ecr-api-endpoint"
  })
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private_eks[*].id
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ecr-dkr-endpoint"
  })
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(aws_route_table.private_eks[*].id, aws_route_table.private_db[*].id)

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-s3-endpoint"
  })
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private_eks[*].id
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-secretsmanager-endpoint"
  })
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private_eks[*].id
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-logs-endpoint"
  })
}

resource "aws_vpc_endpoint" "sts" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.sts"
  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private_eks[*].id
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-sts-endpoint"
  })
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2"
  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private_eks[*].id
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-endpoint"
  })
}

resource "aws_vpc_endpoint" "elasticloadbalancing" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.elasticloadbalancing"
  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private_eks[*].id
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-elb-endpoint"
  })
}
