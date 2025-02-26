resource "aws_security_group" "nlb_sg" {
  name        = "${var.all_vars_prefix}-nlb-sg"
  description = "Allow inbound traffic from anywhere to the NLB on port 6379 and outbound to ASG"
  vpc_id      = aws_vpc.po_main_vpc.id

  tags = {
    Name = "${var.all_vars_prefix}-sg-nlb"
  }
}
resource "aws_vpc_security_group_ingress_rule" "nlb_ingress" {
  security_group_id = aws_security_group.nlb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6379
  to_port           = 6379
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "nlb_egress" {
  security_group_id            = aws_security_group.nlb_sg.id
  referenced_security_group_id = aws_security_group.asg_sg.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
}
resource "aws_security_group" "asg_sg" {
  name        = "${var.all_vars_prefix}-asg-sg"
  description = "Allow inbound traffic from NLB on port 6379, and outbound traffic for internet access"
  vpc_id      = aws_vpc.po_main_vpc.id

  tags = {
    Name = "${var.all_vars_prefix}-sg-asg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "asg_ingress" {
  security_group_id            = aws_security_group.asg_sg.id
  referenced_security_group_id = aws_security_group.nlb_sg.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "asg_egress" {
  security_group_id = aws_security_group.asg_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}