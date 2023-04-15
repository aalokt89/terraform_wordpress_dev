output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = [for subnet in module.network.public_subnets : subnet.id]
}
output "private_subnets" {
  value = [for subnet in module.network.private_subnets : subnet.id]
}
