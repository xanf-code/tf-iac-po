resource "aws_internet_gateway" "po_igw" {
  vpc_id = aws_vpc.po_main_vpc.id
  tags = {
    Name = "${var.all_vars_prefix}-po-internet-gateway"
  }
}

resource "aws_route_table" "po_public_rt" {
  vpc_id = aws_vpc.po_main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.po_igw.id
  }
  tags = {
    Name = "${var.all_vars_prefix}-po-public-route-table"
  }
}

resource "aws_route_table_association" "po_public_rt_association_1" {
  route_table_id = aws_route_table.po_public_rt.id
  subnet_id      = aws_subnet.po_public_subnet_1.id
}

resource "aws_route_table_association" "po_public_rt_association_2" {
  route_table_id = aws_route_table.po_public_rt.id
  subnet_id      = aws_subnet.po_public_subnet_2.id
}

resource "aws_eip" "po_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "po_nat" {
  allocation_id = aws_eip.po_nat_eip.id
  subnet_id     = aws_subnet.po_public_subnet_1.id
}

resource "aws_route_table" "po_private_rt" {
  vpc_id = aws_vpc.po_main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.po_nat.id
  }
  tags = {
    Name = "${var.all_vars_prefix}-po-private-route-table"
  }
}

resource "aws_route_table_association" "po_private_rt_association_1" {
  route_table_id = aws_route_table.po_private_rt.id
  subnet_id      = aws_subnet.po_private_subnet_1.id
}

resource "aws_route_table_association" "po_private_rt_association_2" {
  route_table_id = aws_route_table.po_private_rt.id
  subnet_id      = aws_subnet.po_private_subnet_2.id
}