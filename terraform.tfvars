app_name    = "wordpress-app"
environment = "DEV"
aws_region  = "us-east-1"
az_count    = 2

# VPC
#----------------------------------------
vpc_cidr             = "10.0.0.0/16"
enable_dns_hostnames = true

# Subnets
#----------------------------------------

# Public
map_public_ip_on_launch = true
public_newbits          = 8
public_newnum           = 100

# Private
private_newbits = 8
private_newnum  = 4

# NAT
#----------------------------------------
enable_nat_gateway     = true
single_nat_gateway     = true
one_nat_gateway_per_az = false
