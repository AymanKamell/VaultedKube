resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = concat(aws_subnet.private_eks[*].id, aws_subnet.private_db[*].id)

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nacl-private"
  })
}

# Inbound: allow from inside VPC (simple baseline)
resource "aws_network_acl_rule" "private_in_vpc_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
}

# Inbound: allow ephemeral ports (for return traffic from internet/EKS API)
resource "aws_network_acl_rule" "private_in_ephemeral" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Outbound: allow all (private subnets go out via NAT by route table)
resource "aws_network_acl_rule" "private_out_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
