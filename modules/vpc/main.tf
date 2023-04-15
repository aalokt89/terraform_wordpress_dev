# Define the VPC
#----------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    "Name" = "var.tags"
  }
}

# Create Internet Gateway
#----------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}
