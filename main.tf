
# Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}

locals {
  app_name    = var.app_name
  environment = var.environment
  region      = var.aws_region
  vpc_cidr    = var.vpc_cidr
  azs         = slice(data.aws_availability_zones.available.names, 0, var.az_count)

}

#Create vpc, subnets, and route tables

module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  version                 = "4.0.1"
  name                    = local.app_name
  cidr                    = local.vpc_cidr
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch

  azs = local.azs

  # publiic subnets
  public_subnets  = [for key, value in local.azs : cidrsubnet(local.vpc_cidr, var.public_newbits, key + var.public_newnum)]
  private_subnets = [for key, value in local.azs : cidrsubnet(local.vpc_cidr, var.private_newbits, key + var.prviate_newnum)]

  # NAT
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

}
