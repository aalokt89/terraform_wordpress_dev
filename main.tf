
# Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}

locals {
  app_name = var.app_name
  region   = var.region
  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  version                 = "4.0.1"
  name                    = local.app_name
  cidr                    = local.vpc_cidr
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch

  #subnets
  azs             = local.azs
  public_subnets  = [for key, value in local.azs : cidrsubnet(local.vpc_cidr, 8, key + 100)]
  private_subnets = [for key, value in local.azs : cidrsubnet(local.vpc_cidr, 8, key + 4)]

  # public_subnet_names   = [for name in var.public_subnet_names : name]
  # database_subnet_names = [for name in var.database_subnet_names : name]


  enable_nat_gateway = var.enable_nat_gateway

  manage_default_route_table    = false
  manage_default_security_group = false
  manage_default_network_acl    = false

}
