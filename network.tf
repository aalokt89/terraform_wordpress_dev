
# Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}

locals {
  name_prefix = lower("${var.app_name}-${var.environment}")
  azs         = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

# Create vpc, subnets, and route tables
#----------------------------------------------------

module "network" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "4.0.1"
  name                 = local.name_prefix
  cidr                 = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames


  azs = local.azs

  # Public subnets
  public_subnets = [for key, value in local.azs : cidrsubnet(var.vpc_cidr, var.public_newbits, key + var.public_newnum)]
  public_subnet_tags = {
    "Tier" = "Web"
  }
  map_public_ip_on_launch = var.map_public_ip_on_launch

  # Private subnets
  private_subnets = [for key, value in local.azs : cidrsubnet(var.vpc_cidr, var.private_newbits, key + var.private_newnum)]
  private_subnet_tags = {
    "Tier" = "Database"
  }

  # NAT
  enable_nat_gateway = var.enable_nat_gateway

  manage_default_network_acl    = false
  manage_default_security_group = false
  manage_default_route_table    = false

}

