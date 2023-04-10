# vpc vars
#----------------------------------------
variable "cidr_block" {
  type        = string
  description = "VPC cidr block"
  default     = ""
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames"
  default     = true
}

variable "tags" {
  default = ""
}
