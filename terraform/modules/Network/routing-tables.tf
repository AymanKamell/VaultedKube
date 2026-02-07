# Public route table (shared)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-rt-public"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private EKS route tables (one per AZ, route to same-AZ NAT)
resource "aws_route_table" "private_eks" {
  count  = 2
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-rt-private-eks-${count.index + 1}"
  })
}

resource "aws_route" "private_eks_default" {
  count                  = 2
  route_table_id         = aws_route_table.private_eks[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private_eks" {
  count          = 2
  subnet_id      = aws_subnet.private_eks[count.index].id
  route_table_id = aws_route_table.private_eks[count.index].id
}

# Private DB route tables (one per AZ, route to same-AZ NAT)
resource "aws_route_table" "private_db" {
  count  = 2
  vpc_id = aws_vpc.this.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-rt-private-db-${count.index + 1}"
  })
}

resource "aws_route" "private_db_default" {
  count                  = 2
  route_table_id         = aws_route_table.private_db[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private_db" {
  count          = 2
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db[count.index].id
}
