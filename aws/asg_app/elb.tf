module "alb" {
  #https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/
  source                     = "terraform-aws-modules/alb/aws"
  version                    = "~> 9.11"
  name                       = "${var.env}-${var.service}"
  internal                   = var.elb_settings["internal"]
  idle_timeout               = var.elb_settings["idle_timeout"]
  load_balancer_type         = var.elb_settings["load_balancer_type"]
  vpc_id                     = var.vpc_id
  subnets                    = var.elb_subnets
  security_groups            = [var.elb_security_group]
  create_security_group      = false
  enable_deletion_protection = false
  tags                       = var.tags

  access_logs = {
    bucket  = var.elb_settings["access_log_bucket"]
    prefix  = "${var.env}-${var.service}"
    enabled = true
  }
}

resource "aws_lb_target_group" "target_group" {
  name                 = "${var.env}-${var.service}"
  port                 = var.elb_settings["target_group_port"]
  protocol             = var.elb_settings["target_group_protocol"]
  protocol_version     = var.elb_settings["target_group_protocol_version"]
  vpc_id               = var.vpc_id
  deregistration_delay = var.elb_settings["deregistration_delay"]
  tags                 = var.tags

  health_check {
    path                = var.elb_settings["health_check_path"]
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = var.elb_settings["health_check_matcher"]
    protocol            = var.elb_settings["health_check_protocol"]
  }
}

resource "aws_lb_listener" "listener_443" {
  load_balancer_arn = module.alb.arn
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = var.elb_settings["certificate_arn"]
  ssl_policy        = var.elb_settings["ssl_policy"]
  tags              = var.tags

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"
  tags              = var.tags

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
