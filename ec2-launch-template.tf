resource "aws_launch_template" "po-launch-template" {
  name          = "${var.all_vars_prefix}-po-launch-template"
  instance_type = "t2.micro"

  key_name               = var.key_pair_name
  image_id               = data.aws_ssm_parameter.amazon_linux_2023.value
  # vpc_security_group_ids = [aws_security_group.asg_sg.id]
  user_data              = filebase64("userdata.tpl")
  
  network_interfaces {
    security_groups = [ aws_security_group.asg_sg.id ]
  }
}