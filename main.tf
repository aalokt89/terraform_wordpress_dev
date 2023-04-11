
# Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}

locals {
  app_name = var.app_name
  region   = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "vpc" {
  source                  = "terraform-aws-modules/vpc/aws"
  name                    = local.app_name
  cidr                    = local.vpc_cidr
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  azs             = local.azs
  public_subnets  = [for key, value in local.azs : cidrsubnet(local.vpc_cidr, 8, key + 100)]
  private_subnets = [for key, value in local.azs : cidrsubnet(local.vpc_cidr, 8, key + 4)]

  # public_subnet_names   = [for name in var.public_subnet_names : name]
  # database_subnet_names = [for name in var.database_subnet_names : name]


  enable_nat_gateway = true

  manage_default_route_table    = false
  manage_default_security_group = false
  manage_default_network_acl    = false

}

resource "aws_main_route_table_association" "public" {
  vpc_id         = module.vpc.vpc_id
  route_table_id = module.vpc.public_route_table_ids[0]
}
