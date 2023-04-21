# Create security groups
#----------------------------------------------------

#ssh
resource "aws_security_group" "ssh_sg" {
  name        = "${local.name_prefix}-ssh-sg"
  description = "Allow ssh."
  vpc_id      = module.network.vpc_id

  ingress {
    description = "ssh from IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = var.sg_timeout
  }

  tags = {
    Name = "${local.name_prefix}-ssh-sg"
  }
}

#http/https for ALB
resource "aws_security_group" "web_access_sg" {
  name        = "${local.name_prefix}-web-access-sg"
  description = "http/https access attached to ALB."
  vpc_id      = module.network.vpc_id

  # http
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # https
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # all
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  timeouts {
    delete = var.sg_timeout
  }
  tags = {
    Name = "${local.name_prefix}-web-access-sg"
  }
}

# wordpress rds sg
resource "aws_security_group" "wordpress_rds" {
  name        = "${local.name_prefix}-wordpress-rds-sg"
  description = "Allows inbound traffic from wordpress ec2s. Attached to rds"
  vpc_id      = module.network.vpc_id

  # to ec2
  ingress {
    description     = "traffic from ec2 sg"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_ec2_sg.id]
  }
  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = var.sg_timeout
  }

  tags = {
    Name = "${local.name_prefix}-wordpress-rds-sg"
  }
}


# wordpress ec2 sg
resource "aws_security_group" "wordpress_ec2_sg" {
  name        = "${local.name_prefix}-wordpress-ec2-sg"
  description = "Allows inbound http/https traffic from ALB sg and all outboound traffic. Attached to ec2"
  vpc_id      = module.network.vpc_id

  # http
  ingress {
    description     = "http from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_access_sg.id]
  }
  # https
  ingress {
    description     = "https from ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web_access_sg.id]
  }
  # all
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = var.sg_timeout
  }

  tags = {
    Name = "${local.name_prefix}-wordpress-ec2-sg"
  }
}

