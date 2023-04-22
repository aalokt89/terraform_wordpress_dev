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
  depends_on = [aws_db_instance.wordpress, aws_lb.web_alb]
  source     = "terraform-aws-modules/autoscaling/aws"
  version    = "6.9.0"

  name                = "${local.name_prefix}-${var.wordpress_server_name}-asg"
  min_size            = var.wordpress_asg_min_size
  max_size            = var.wordpress_asg_max_size
  health_check_type   = var.wordpress_asg_health_check_type
  vpc_zone_identifier = module.network.public_subnets
  target_group_arns   = [aws_lb_target_group.web_alb_tg_http.arn]


  # Launch template
  launch_template_name        = "${var.wordpress_server_name}-template"
  launch_template_description = "WordPress instances"

  image_id          = data.aws_ami.amazon_linux2.id
  instance_type     = var.wordpress_template_instance_type
  enable_monitoring = var.wordpress_template_enable_monitoring
  security_groups   = [aws_security_group.ssh_sg.id, aws_security_group.wordpress_ec2_sg.id]
  key_name          = var.key_name

  user_data = base64encode(data.template_file.user_data.rendered)

  # scaling_policies = {
  #   avg-cpu-policy-greater-than-75 = {
  #     policy_type = var.wordpress_asg_scaling_policy_type
  #     target_tracking_configuration = {
  #       predefined_metric_specification = {
  #         predefined_metric_type = var.wordpress_asg_scaling_policy_metric_type
  #       }
  #       target_value = var.wordpress_asg_scaling_policy_target_value
  #     }
  #   }
  # }

  tags = {
    Name = "${local.name_prefix}-${var.wordpress_server_name}-asg"
  }
}

# user data wordpress script template
data "template_file" "user_data" {
  template = file("${path.module}/install_wordpress.tpl")
  vars = {
    db_username = var.db_username
    db_password = var.db_password
    db_name     = var.db_name
    db_host     = aws_db_instance.wordpress.address

    wp_username = var.wp_username
    wp_password = var.wp_password
    wp_email    = var.wp_email
    wp_url      = aws_lb.web_alb.dns_name
    wp_title    = var.app_name
  }
}
