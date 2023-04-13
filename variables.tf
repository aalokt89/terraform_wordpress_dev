# environment vars
#---------------------------------------
variable "environment" {
  type    = string
  default = "DEV"

  validation {
    condition     = contains(["DEV", "QA", "PROD"], upper(var.environment)
    error_message = "The 'environment' tag must be one of 'DEV','QA', or 'PROD'."
  }
  validation {
    condition     = upper(var.environment) == var.environment
    error_message = "The 'environment' tag must be alll in uppercase."
  }
}
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "az_count" {
  type        = number
  description = "Number of availability zones to use"
  default     = 2
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
  default     = 4
}

# NAT gateway
#----------------------------------------
variable "enable_nat_gateway" {
  type        = bool
  description = "enable NAT gateway"
  default     = true
}
variable "single_nat_gateway" {
  type        = bool
  description = "enable single NAT"
  default     = true
}
variable "one_nat_gateway_per_az" {
  type        = bool
  description = "enable NAT gateway in each AZ"
  default     = false
}

