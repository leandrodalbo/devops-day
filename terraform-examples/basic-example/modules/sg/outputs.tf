output "alb_sg_id" {
  value = aws_security_group.alb-sg.id
}

output "ec2_sg_name" {
  value = aws_security_group.ec2-security-group.name
}

