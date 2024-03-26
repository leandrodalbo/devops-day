# Security Groups EC2
resource "aws_security_group" "ec2-security-group" {
  name = var.ec2-sg-name
}

resource "aws_security_group_rule" "http_inbound_ec2" {
  type              = "ingress"
  security_group_id = aws_security_group.ec2-security-group.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


# Load Balancer Security Groups
resource "aws_security_group" "alb-sg" {
  name = var.lb-sg-name
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

