# environment vars
#---------------------------------------
variable "environment" {
  type    = string
  default = "Dev"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# App name
#---------------------------------------
variable "app_name" {
  type        = string
  description = "app name prefix for naming"
  default     = "wordpress-app"
}

# VPC
#----------------------------------------
variable "vpc_cidr" {
  type        = string
  description = "VPC cidr"
  default     = "10.0.0.0/16"
}
variable "vpc_enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames"
  default     = true
}

# Subnets
#----------------------------------------

# Public
variable "public_subnet_names" {
  default = ["public-subnet-1", "public-subnet-2"]
}
variable "map_public_ip_on_launch" {
  type        = bool
  description = "enable auto-assign ipv4"
  default     = true
}

# Private
variable "database_subnet_names" {
  default = ["db-subnet-1", "db-subnet-2"]
}

# NAT gateway
#----------------------------------------
variable "enable_nat_gateway" {
  type        = bool
  description = "enable NAT gateway"
  default     = true
}
variable "one_nat_gateway_per_az" {
  type        = bool
  description = "enable NAT gateway in each AZ"
  default     = true
}

