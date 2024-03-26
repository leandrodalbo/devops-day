#Load Balancer
resource "aws_lb" "load_balancer" {
  name               = var.load_balancer_name
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets_ids
  security_groups    = var.alb_sg_ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn

  port     = var.load_balancer_port
  protocol = var.load_balancer_protocol

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
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.target_group_vpc_id

  health_check {
    path                = "/"
    protocol            = var.load_balancer_protocol
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "core_lb_instances" {
  count = length(var.target_group_instances)

  target_group_arn = aws_lb_target_group.ec2-targets.arn
  target_id        = var.target_group_instances[count.index]
  port             = var.target_group_port
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
