resource "aws_subnet" "po_public_subnet_1" {
  vpc_id            = aws_vpc.po_main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.all_vars_prefix}-po-public-subnet-1"
  }
}

resource "aws_subnet" "po_public_subnet_2" {
  vpc_id            = aws_vpc.po_main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.all_vars_prefix}-po-public-subnet-2"
  }
}

resource "aws_subnet" "po_private_subnet_1" {
  vpc_id            = aws_vpc.po_main_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.all_vars_prefix}-po-private-subnet-1"
  }
}

resource "aws_subnet" "po_private_subnet_2" {
  vpc_id            = aws_vpc.po_main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.all_vars_prefix}-po-private-subnet-2"
  }
}