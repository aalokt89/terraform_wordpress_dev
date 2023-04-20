# Create RDS
#----------------------------------------------------

resource "aws_db_instance" "wordpress" {
  identifier             = var.db_identifier
  allocated_storage      = var.db_allocated_storage
  max_allocated_storage  = var.db_max_allocated_storage
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  availability_zone      = local.azs[0]
  publicly_accessible    = var.db_publicly_accessible
  deletion_protection    = var.db_deletion_protection
  db_subnet_group_name   = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [aws_security_group.wordpress_rds.id]
  skip_final_snapshot    = var.db_skip_final_snapshot

  tags = {
    "Name" = "${local.name_prefix}-${var.db_name}-db"
  }
}

resource "aws_db_subnet_group" "wordpress" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = module.network.private_subnets

  tags = {
    Name = "${local.name_prefix}-db-subnet-group"
  }
}
# module "wordpress_db" {
#   source                = "terraform-aws-modules/rds/aws"
#   version               = "5.6.0"
#   identifier            = var.db_identifier
#   allocated_storage     = var.db_allocated_storage
#   max_allocated_storage = var.db_max_allocated_storage

#   db_name                = var.db_name
#   username               = var.db_username
#   password               = var.db_password
#   create_random_password = var.db_create_random_password
#   port                   = var.db_port

#   engine         = var.db_engine
#   engine_version = var.db_engine_version

#   family               = var.db_family
#   major_engine_version = var.db_major_engine_version
#   instance_class       = var.db_instance_class

#   vpc_security_group_ids = [aws_security_group.wordpress_rds.id]

#   create_db_subnet_group = var.create_db_subnet_group
#   subnet_ids             = module.network.private_subnets
#   availability_zone      = var.db_availability_zone

#   publicly_accessible = var.db_publicly_accessible
#   deletion_protection = var.db_deletion_protection

#   tags = {
#     "Name" = "${local.name_prefix}-db"
#   }
# }
