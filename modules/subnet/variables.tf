variable "subnets" {
  type        = map(any)
  description = "list of subnets"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC cidr block"
  default     = ""
}

variable "cidr_newbits" {
  type        = number
  description = "Number to add to subnet mask"
}

variable "cidr_newnum" {
  type        = number
  description = "value"
}

variable "availability_zones" {
  type        = list(any)
  description = "List of availability zones"
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = false
}

# route table vars
#----------------------------------------
variable "route_cidr" {
  type = string
}
variable "igw_id" {
  type = string
}
variable "custom_tags" {
  type        = map(string)
  description = "Custom tags"
  default = {
  }

}
