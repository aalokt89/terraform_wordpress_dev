module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc["cidr_block"]

}

module "public_subnets" {
  source                  = "./modules/subnet"
  subnets                 = var.public_subnets
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = var.vpc["cidr_block"]
  cidr_newbits            = 8
  cidr_newnum             = 100
  availability_zones      = data.aws_availability_zones.available.names
  map_public_ip_on_launch = var.map_public_ip_on_launch

  route_cidr = "0.0.0.0/0"
  igw_id     = module.vpc.igw_id


}
