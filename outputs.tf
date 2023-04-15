output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnets
}
output "private_subnets" {
  value = module.network.private_subnets
}
