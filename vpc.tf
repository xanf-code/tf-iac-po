resource "aws_vpc" "po_main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.all_vars_prefix}-po-main-vpc"
  }
}