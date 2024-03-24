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
provider "aws" {
  region = "eu-west-1"

}

# VPC - Using default

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

# Security Groups EC2

resource "aws_security_group" "ec2-security-group" {
  name = "ec2-sg"
}

resource "aws_security_group_rule" "http_inbound_ec2" {
  type              = "ingress"
  security_group_id = aws_security_group.ec2-security-group.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


# EC2 Instances
resource "aws_instance" "machine_0" {
  ami             = "ami-0c1c30571d2dae5c9"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2-security-group.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "echo from machine 0" > index.html
              python3 -m http.server 8080 &
              EOF
}

resource "aws_instance" "machine_1" {
  ami             = "ami-0c1c30571d2dae5c9"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.ec2-security-group.name]
  user_data       = <<-EOF
              #!/bin/bash
              echo "echo from machine 1" > index.html
              python3 -m http.server 8080 &
              EOF
}



# Load Balancer Security Groups

resource "aws_security_group" "alb-sg" {
  name = "alb-security-group"
}

resource "aws_security_group_rule" "alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb-sg.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

}



resource "aws_security_group_rule" "alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb-sg.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

}


#Load Balancer
resource "aws_lb" "load_balancer" {
  name               = "example-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default_subnets.ids
  security_groups    = [aws_security_group.alb-sg.id]

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn

  port = 80

  protocol = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "ec2-targets" {
  name     = "example-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "machine_0" {
  target_group_arn = aws_lb_target_group.ec2-targets.arn
  target_id        = aws_instance.machine_0.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "machine_1" {
  target_group_arn = aws_lb_target_group.ec2-targets.arn
  target_id        = aws_instance.machine_1.id
  port             = 8080
}

resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-targets.arn
  }
}



