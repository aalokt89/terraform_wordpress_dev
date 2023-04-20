# environment vars
#---------------------------------------
variable "environment" {
  type    = string
  default = "DEV"

  validation {
    condition     = contains(["DEV", "QA", "PROD"], upper(var.environment))
    error_message = "The 'environment' tag must be one of 'DEV','QA', or 'PROD'."
  }
  validation {
    condition     = upper(var.environment) == var.environment
    error_message = "The 'environment' tag must be in all in uppercase."
  }
}
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}
variable "app_name" {
  type        = string
  description = "app name prefix for naming"
  default     = "wordpressapp"
}

variable "az_count" {
  type        = number
  description = "Number of availability zones to use"
  default     = 2
}

# VPC
#----------------------------------------
variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "vpc"
}
variable "vpc_cidr" {
  type        = string
  description = "VPC cidr"
  default     = "10.0.0.0/16"
}
variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames"
  default     = true
}

# Subnets
#----------------------------------------

# Public
variable "map_public_ip_on_launch" {
  type        = bool
  description = "enable auto-assign ipv4"
  default     = true
}
variable "public_newbits" {
  type        = number
  description = "number to add for public_subnet 'newbits' cidrsubnet() function"
  default     = 8
}
variable "public_newnum" {
  type        = number
  description = "number to add for public_subnet 'newnum' cidrsubnet() function"
  default     = 100
}

# Private
variable "private_newbits" {
  type        = number
  description = "number to add for private_subnet 'newbits' cidrsubnet() function"
  default     = 8
}
variable "private_newnum" {
  type        = number
  description = "number to add for private_subnet 'newnum' cidrsubnet() function"
  default     = 8
}

# NAT gateway
#----------------------------------------
variable "enable_nat_gateway" {
  type        = bool
  description = "enable NAT gateway"
  default     = false
}
variable "single_nat_gateway" {
  type        = bool
  description = "enable single NAT"
  default     = false
}
variable "one_nat_gateway_per_az" {
  type        = bool
  description = "enable NAT gateway in each AZ"
  default     = false
}

# Security groups
#----------------------------------------
variable "sg_timeout" {
  type        = string
  description = "Security group delete timeout"
  default     = "5m"
}
variable "ssh_cidr" {
  type        = string
  description = "ssh cidrs"
  default     = "0.0.0.0/0"
}
variable "db_port" {
  type        = number
  description = "wordpress db port"
  default     = 3306
}

# RDS wordpress
#----------------------------------------
variable "db_identifier" {
  type        = string
  description = "db instance name"
  default     = "wordpress"
}
variable "db_allocated_storage" {
  type        = number
  description = "db allocated storage"
  default     = 20
}
variable "db_max_allocated_storage" {
  type        = number
  description = "wordpress db max allocated storage"
  default     = 500
}
variable "db_name" {
  type        = string
  description = "wordpress db name"
}
variable "db_instance_class" {
  type        = string
  description = "wordpress db instance type"
  default     = "db.t2.micro"
}
variable "db_username" {
  type        = string
  description = "wordpress db username"
  sensitive   = true
}
variable "db_password" {
  type        = string
  description = "wordpress db password"
  sensitive   = true
}
variable "db_engine" {
  type        = string
  description = "wordpress db engine"
  default     = "mysql"
}
variable "db_engine_version" {
  type        = string
  description = "wordpress db engine version"
  default     = "8.0.32"
}
variable "db_publicly_accessible" {
  type        = bool
  description = "wordpress db publicly accessible"
  default     = false
}
variable "db_deletion_protection" {
  type        = bool
  description = "wordpress db deletion protection"
  default     = false
}
variable "db_availability_zone" {
  type        = string
  description = "wordpress db engine version"
  default     = "us-east-1a"
}
variable "db_skip_final_snapshot" {
  type        = bool
  description = "skip final snapshot"
  default     = true
}
variable "db_final_snapshot_identifier" {
  type        = string
  description = "final snapshot name"
  default     = "wordpress-final-snapshot"
}

