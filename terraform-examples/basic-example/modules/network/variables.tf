variable "use_default_vpc" {
  type    = bool
  default = true
}

variable "vpc_name" {
  type    = string
  default = "vpc-id"
}

variable "aws_region" {
  type = string
}
