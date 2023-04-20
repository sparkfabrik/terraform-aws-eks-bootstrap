output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "service_subnet_ids" {
  value = [
    for subnet in aws_subnet.service_subnet :
    subnet.id
  ]
}
