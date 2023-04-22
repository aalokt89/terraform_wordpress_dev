
# Get amazon linux 2 ami
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Autoscaling group
#----------------------------------------
module "wordpress_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.9.0"

  name = "${local.name_prefix}-${var.wordpress_server_name}-asg"
  min_size            = var.wordpress_asg_min_size
  max_size            = var.wordpress_asg_max_size
  health_check_type   = var.wordpress_asg_health_check_type
  vpc_zone_identifier = module.network.public_subnets
  target_group_arns = [aws_lb_target_group.web_alb_tg_http.arn]


  # Launch template
  launch_template_name        = "${var.wordpress_server_name}-template"
  launch_template_description = "WordPress instances"

  image_id          = data.aws_ami.amazon_linux2.id
  instance_type     = var.wordpress_template_instance_type
  enable_monitoring = var.wordpress_template_enable_monitoring
  security_groups = [aws_security_group.ssh_sg.id, aws_security_group.wordpress_ec2_sg.id]
  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install -y httpd mysql
            sudo systemctl start httpd
            sudo systemctl enable httpd

            sudo amazon-linux-extras install -y php7.4
            sudo amazon-linux-extras enable php7.4
            sudo yum clean metadata
            sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd

            #Change OWNER and permission of directory /var/www
            sudo usermod -a -G apache ec2-user
            sudo chown -R ec2-user:apache /var/www
            sudo find /var/www -type d -exec chmod 2775 {} \;
            sudo find /var/www -type f -exec chmod 0664 {} \;

            # Download and install the WordPress CLI
            sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
            sudo chmod +x wp-cli.phar
            sudo mv wp-cli.phar /usr/local/bin/wp

            # Create the WordPress configuration file
            cd /var/www/html
            wp core download --allow-root
            wp config create --dbname=wordpress --dbuser=admin --dbpass=password --dbhost=wordpress.cgwzuzkgdaxy.us-east-1.rds.amazonaws.com --allow-root

            # Set the appropriate permissions
            sudo chown -R apache:apache /var/www/html
            sudo chmod -R 755 /var/www/html
            sudo systemctl restart httpd.service
            EOF



  scaling_policies = {
    avg-cpu-policy-greater-than-75 = {
      policy_type               = var.wordpress_asg_scaling_policy_type
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = var.wordpress_asg_scaling_policy_metric_type
        }
        target_value = var.wordpress_asg_scaling_policy_target_value
      }
    }
  }

  tags = {
    Name = "${local.name_prefix}-${var.wordpress_server_name}-asg"
  }
}