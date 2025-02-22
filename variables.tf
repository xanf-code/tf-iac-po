variable "key_pair_name" {
  type    = string
  default = "<key_name_here>"
}

variable "asg_desired_capacity" {
  type    = number
  default = 0
}
variable "asg_min_capacity" {
  type    = number
  default = 0
}
variable "asg_max_capacity" {
  type    = number
  default = 0
}

variable "ami_ssm_parameter_path" {
  type    = string
  default = "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-6.1-x86_64"
}

variable "all_vars_prefix" {
  type = string
}

variable "capacity_distribution_strategy" {
  type    = string
  default = "balanced-best-effort"
}

variable "domain_name_hosted_zone" {
  type    = string
  default = "<domain-name-here>"
}

variable "time_zone" {
  type    = string
  default = "America/New_York"
}

variable "account_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "git_repo_link" {
  type = string
}

variable "docker_username" {
  type = string
}

variable "docker_password" {
  type = string
}