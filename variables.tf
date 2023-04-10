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
# naming vars
#---------------------------------------
variable "app_name" {
  type        = string
  description = "app name prefix for naming"
  default     = "shoppr"
}

# vpc vars
#----------------------------------------
variable "vpc" {
  type        = map(any)
  description = "VPC vars"
  default = {
    cidr_block = "10.0.0.0/16"
  }
}

# public subnet vars
#----------------------------------------
# private subnet vars
#----------------------------------------
variable "public_subnets" {
  default = {
    "private-subnet-1" = 0
    "private-subnet-2" = 1
  }
}
variable "map_public_ip_on_launch" {
  type        = bool
  description = "enable auto-assign ipv4"
  default     = true
}
