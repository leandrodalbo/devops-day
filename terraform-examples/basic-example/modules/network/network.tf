# VPC - Using default
data "aws_vpc" "default_vpc" {
  default = var.use_default_vpc
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = var.vpc_name
    values = [data.aws_vpc.default_vpc.id]
  }
}
