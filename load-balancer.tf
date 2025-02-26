resource "aws_lb" "po-load-balancer" {
  name               = "${var.all_vars_prefix}-po-load-balancer"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb_sg.id]
  subnets            = [aws_subnet.po_public_subnet_1.id, aws_subnet.po_public_subnet_2.id]
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "forward_to_target_group_http_listener" {
  load_balancer_arn = aws_lb.po-load-balancer.arn
  port              = 6379
  protocol          = "TCP"

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
