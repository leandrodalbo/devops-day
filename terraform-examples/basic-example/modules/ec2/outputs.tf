output "instances_ids" {
  value = [aws_instance.machine_0.id, aws_instance.machine_1.id]
}
