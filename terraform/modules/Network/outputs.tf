output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_eks_subnet_ids" {
  value = aws_subnet.private_eks[*].id
}

output "private_db_subnet_ids" {
  value = aws_subnet.private_db[*].id
}

output "sg_alb_id" {
  value = aws_security_group.alb.id
}

output "sg_eks_nodes_id" {
  value = aws_security_group.eks_nodes.id
}

output "sg_db_id" {
  value = aws_security_group.db.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.this[*].id
}
