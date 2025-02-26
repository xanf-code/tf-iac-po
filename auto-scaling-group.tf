resource "aws_autoscaling_group" "po-asg" {
  name                      = "${var.all_vars_prefix}-auto-scaling-group"
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_max_capacity
  min_size                  = var.asg_min_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 300

  vpc_zone_identifier = [aws_subnet.po_private_subnet_1.id, aws_subnet.po_private_subnet_2.id]

  launch_template {
    id      = aws_launch_template.po-launch-template.id
    version = aws_launch_template.po-launch-template.latest_version
  }

  availability_zone_distribution {
    capacity_distribution_strategy = var.capacity_distribution_strategy
  }

  target_group_arns = [aws_lb_target_group.po-lb-target-group.arn]

  tag {
    key = "Name"
    value = "${var.all_vars_prefix}-auto-scaling-group-redis"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "auto-shutdown-asg-schedule" {
  scheduled_action_name  = "${var.all_vars_prefix}-auto-shut-down-schedule"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 0 * * *"
  time_zone              = var.time_zone
  autoscaling_group_name = aws_autoscaling_group.po-asg.name
}

resource "aws_autoscaling_schedule" "auto-startup-asg-schedule" {
  scheduled_action_name  = "${var.all_vars_prefix}-auto-start-up-schedule"
  min_size               = 1
  max_size               = 1
  desired_capacity       = 1
  recurrence             = "0 6 * * *"
  time_zone              = var.time_zone
  autoscaling_group_name = aws_autoscaling_group.po-asg.name
}