resource "aws_lb" "po-load-balancer" {
  name               = "${var.all_vars_prefix}-po-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_traffic_load_balancer.id]
  subnets            = [aws_subnet.po_public_subnet_1.id, aws_subnet.po_public_subnet_2.id]
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "forward_to_target_group_http_listener" {
  load_balancer_arn = aws_lb.po-load-balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.po-lb-target-group.arn
  }
}

# resource "aws_lb_listener" "forward_to_target_group_https_listener" {
#   load_balancer_arn = aws_lb.po-load-balancer.arn
#   port              = 443
#   protocol          = "HTTPS"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.po-lb-target-group.arn
#   }
#   certificate_arn = aws_acm_certificate.po-cert.arn
# }
