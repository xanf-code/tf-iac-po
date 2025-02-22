resource "aws_security_group" "allow_traffic_load_balancer" {
  name        = "${var.all_vars_prefix}-allow_traffic_load_balancer"
  description = "Allow TLS inbound traffic and all outbound traffic into load balancer"
  vpc_id      = aws_vpc.po_main_vpc.id

  tags = {
    Name = "${var.all_vars_prefix}-sg-po-load-balancer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_traffic_lb" {
  security_group_id = aws_security_group.allow_traffic_load_balancer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_traffic_lb" {
  security_group_id = aws_security_group.allow_traffic_load_balancer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_lb" {
  security_group_id = aws_security_group.allow_traffic_load_balancer.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_https_traffic_ipv4_lb" {
  security_group_id = aws_security_group.allow_traffic_load_balancer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_security_group" "allow_traffic_asg" {
  name        = "${var.all_vars_prefix}-allow_traffic_asg"
  description = "Allow TLS inbound traffic and all outbound traffic into ASG"
  vpc_id      = aws_vpc.po_main_vpc.id

  tags = {
    Name = "${var.all_vars_prefix}-sg-po-asg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_all_traffic" {
  security_group_id = aws_security_group.allow_traffic_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id            = aws_security_group.allow_traffic_asg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
  referenced_security_group_id = aws_security_group.allow_traffic_load_balancer.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_traffic_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_https_traffic_ipv4" {
  security_group_id = aws_security_group.allow_traffic_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_security_group" "allow_traffic_custom_vpc" {
  name        = "${var.all_vars_prefix}-allow_traffic_default_vpc"
  description = "Allow incoming traffic and outbound traffic into custom vpc"
  vpc_id      = aws_vpc.po_main_vpc.id

  tags = {
    Name = "${var.all_vars_prefix}-sg-po-custom-vpc"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_vpc_traffic_custom_vpc" {
  security_group_id            = aws_security_group.allow_traffic_custom_vpc.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.allow_traffic_custom_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_traffic_custom_vpc" {
  security_group_id = aws_security_group.allow_traffic_custom_vpc.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_custom_vpc" {
  security_group_id = aws_security_group.allow_traffic_custom_vpc.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}