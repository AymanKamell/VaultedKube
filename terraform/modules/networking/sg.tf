# ALB security group

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-sg-alb"
  description = "ALB security group"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-sg-alb"
  })
}


# EKS-nodes security group

resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-sg-eks-nodes"
  description = "EKS worker nodes"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Node to node"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-sg-eks-nodes"
  })
}

# Database security groups

resource "aws_security_group" "db" {
  name        = "${var.project_name}-sg-db"
  description = "Database security group"
  vpc_id      = aws_vpc.this.id

  ingress {
    description     = "From EKS nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-sg-db"
  })
}
