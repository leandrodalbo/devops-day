variable "aws_region" {
  type = string
}

variable "load_balancer_name" {
  type    = string
  default = "example-alb"
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}


variable "subnets_ids" {
  default = []
}

variable "alb_sg_ids" {
  default = []
}

variable "load_balancer_port" {
  type    = number
  default = 80
}

variable "load_balancer_protocol" {
  type    = string
  default = "HTTP"
}

variable "target_group_name" {
  type    = string
  default = "example-target-group"
}

variable "target_group_port" {
  type    = number
  default = 8080
}

variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}


variable "target_group_vpc_id" {
  type = string
}

variable "target_group_instances" {
  default = []
}
