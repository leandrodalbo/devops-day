variable "aws_region" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "sg_name" {
  type    = string
  default = "sg_name"
}

