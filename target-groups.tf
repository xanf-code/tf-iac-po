resource "aws_lb_target_group" "po-lb-target-group" {
  name        = "${var.all_vars_prefix}-po-target-group-alb-tg"
  target_type = "instance"
  vpc_id      = aws_vpc.po_main_vpc.id
  port        = 6379
  protocol    = "TCP"

  health_check {
    protocol            = "TCP"
    port                = 6379
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}