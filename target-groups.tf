resource "aws_lb_target_group" "po-lb-target-group" {
  name        = "${var.all_vars_prefix}-po-target-group-alb-tg"
  target_type = "instance"
  vpc_id      = aws_vpc.po_main_vpc.id
  port        = 80
  protocol    = "HTTP"
}