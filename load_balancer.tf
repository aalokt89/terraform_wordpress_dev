# Create ALB, listener, and target groups
#----------------------------------------------------

# ALB
resource "aws_lb" "web_alb" {
  name               = "${local.name_prefix}-${var.web_alb_name}"
  internal           = var.web_alb_internal
  load_balancer_type = var.web_alb_type
  security_groups    = [aws_security_group.web_access_sg.id]
  subnets            = module.network.public_subnets

  tags = {
    Name = "${local.name_prefix}-${var.web_alb_name}"
  }
}

# ALB target groups 
#----------------------------------------
# HTTP
resource "aws_lb_target_group" "web_alb_tg_http" {
  depends_on = [aws_lb.web_alb]
  name       = "${var.web_alb_name}-${var.web_alb_tg_http_name}"
  port       = var.web_alb_tg_http_port
  protocol   = var.web_alb_tg_http_protocol
  vpc_id     = module.network.vpc_id

  tags = {
    Name = "${var.web_alb_name}-${var.web_alb_tg_http_name}"
  }
}

# ALB listeners
#----------------------------------------
# HTTP
resource "aws_lb_listener" "web_alb_listener_http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = var.web_alb_listener_http_port
  protocol          = var.web_alb_listener_http_protocol

  default_action {
    type             = var.web_alb_listener_http_action_type
    target_group_arn = aws_lb_target_group.web_alb_tg_http.arn
  }
}
