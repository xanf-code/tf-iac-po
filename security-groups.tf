resource "aws_security_group" "allow_traffic_load_balancer" {
  name        = "${var.all_vars_prefix}-allow_traffic_load_balancer"
  description = "Allow TLS inbound traffic and all outbound traffic into load balancer"
  vpc_id      = aws_vpc.po_main_vpc.id

  tags = {
    Name = "${var.all_vars_prefix}-sg-po-load-balancer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_redis_traffic_lb" {
  security_group_id = aws_security_group.allow_traffic_load_balancer.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 6379
  ip_protocol       = "tcp"
  to_port           = 6379
}

resource "aws_vpc_security_group_egress_rule" "allow_lb_to_redis" {
  security_group_id            = aws_security_group.allow_traffic_load_balancer.id
  referenced_security_group_id = aws_security_group.allow_traffic_asg.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
}

resource "aws_security_group" "allow_traffic_asg" {
  name        = "${var.all_vars_prefix}-allow_traffic_asg"
  description = "Allow TLS inbound traffic and all outbound traffic into ASG"
  vpc_id      = aws_vpc.po_main_vpc.id

  tags = {
    Name = "${var.all_vars_prefix}-sg-po-asg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_redis_from_nlb" {
  security_group_id            = aws_security_group.allow_traffic_asg.id
  referenced_security_group_id = aws_security_group.allow_traffic_load_balancer.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_traffic_asg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
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