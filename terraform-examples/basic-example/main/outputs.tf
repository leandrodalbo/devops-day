output "machine-0-arn" {
  value = aws_instance.machine_0.arn
}

output "machine-1-arn" {
  value = aws_instance.machine_0.arn
}


output "load_balancer_dns" {
  value = aws_lb.load_balancer.dns_name
}
