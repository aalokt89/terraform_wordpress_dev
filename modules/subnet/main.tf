# Subnets 
resource "aws_subnet" "subnets" {
  for_each          = var.subnets
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.cidr_newbits, each.value + var.cidr_newnum)
  availability_zone = tolist(var.availability_zones)[each.value]

  map_public_ip_on_launch = var.map_public_ip_on_launch

  dynamic "tag" {
    for_each = var.custom_tags

    content {
      key   = tag.key
      value = tag.value
    }

  }
}

#Route table
resource "aws_default_route_table" "public_rt" {
  default_route_table_id = var.vpc_id

  route {
    cidr_block = var.route_cidr
    gateway_id = var.igw_id
  }
}

# Subnet associations
resource "aws_route_table_association" "public" {
  depends_on     = [aws_subnet.subnets]
  route_table_id = aws_default_route_table.public_rt.id
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
}
