variable "aws_region" {
  type = string
}

variable "ec2-sg-name" {
  type    = string
  default = "ec2-sg"
}

variable "lb-sg-name" {
  type    = string
  default = "alb-security-group"
}
