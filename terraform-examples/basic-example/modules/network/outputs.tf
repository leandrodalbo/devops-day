output "subnets_ids" {
  value = data.aws_subnets.default_subnets.ids
}

output "vpc_id" {
  value = data.aws_vpc.default_vpc.id
}


