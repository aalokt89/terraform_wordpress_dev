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
  default     = "wordpress"
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
variable "public_subnet_names" {
  default = ["public-subnet-1", "public-subnet-2"]
}

variable "database_subnet_names" {
  default = ["db-subnet-1", "db-subnet-2"]
}
variable "map_public_ip_on_launch" {
  type        = bool
  description = "enable auto-assign ipv4"
  default     = true
}
