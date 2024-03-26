terraform {
  backend "s3" {
    bucket  = "basic-example-state"
    key     = "basic-example/main/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


module "network" {
  source = "../modules/network"

  aws_region = var.aws_region
}

module "security-groups" {
  source = "../modules/sg"

  aws_region = var.aws_region
}

module "ec2" {
  source = "../modules/ec2"

  ami           = var.ami
  instance_type = var.instance_type
  aws_region    = var.aws_region
  sg_name       = module.security-groups.ec2_sg_name
}

module "lb" {
  source = "../modules/balancer"

  aws_region             = var.aws_region
  subnets_ids            = module.network.subnets_ids
  alb_sg_ids             = [module.security-groups.alb_sg_id]
  target_group_vpc_id    = module.network.vpc_id
  target_group_instances = module.ec2.instances_ids

}



