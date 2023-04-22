output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnets
}
output "private_subnets" {
  value = module.network.private_subnets
}

output "wordpress_db_endpoint" {
  value = aws_db_instance.wordpress.address
}

output "alb_dns" {
  description = "ALB public DNS"
  value       = "http://${aws_lb.web_alb.dns_name}"
}
