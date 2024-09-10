module "access_log_bucket" {
  count                          = var.create_elb ? 1 : 0
  source                         = "terraform-aws-modules/s3-bucket/aws"
  version                        = "~> 3.0"
  bucket                         = "${var.company_name}-${var.world}-${var.service}-alb-access-logs"
  acl                            = "log-delivery-write"
  force_destroy                  = true
  control_object_ownership       = true
  object_ownership               = "ObjectWriter"
  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true
  tags                           = var.tags
  lifecycle_rule = [
    {
      id      = "delete-old-logs"
      enabled = true

      expiration = {
        days = var.elb_settings["access_logs_expiry"]
      }
    }
  ]
}

module "alb" {
  #https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/6.4.0
  count                      = var.create_elb ? 1 : 0
  source                     = "terraform-aws-modules/alb/aws"
  version                    = "~> 9.11"
  name                       = "${var.world}-${var.service}"
  internal                   = var.elb_settings["internal"]
  idle_timeout               = var.elb_settings["idle_timeout"]
  load_balancer_type         = var.elb_settings["load_balancer_type"]
  vpc_id                     = var.vpc_id
  subnets                    = var.elb_subnets
  security_groups            = [var.elb_security_group]
  create_security_group      = false
  enable_deletion_protection = false

  access_logs = {
    bucket  = module.access_log_bucket[0].s3_bucket_id
    enabled = true
  }

  tags = var.tags
}

resource "aws_lb_target_group" "target_group" {
  count                = var.create_elb ? 1 : 0
  name                 = "${var.world}-${var.service}"
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
  }
}

resource "aws_lb_listener" "listener_443" {
  count             = var.create_elb ? 1 : 0
  load_balancer_arn = module.alb[0].arn
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = var.elb_certificate_arn
  ssl_policy        = var.elb_settings["ssl_policy"]
  tags              = var.tags

  default_action {
    target_group_arn = aws_lb_target_group.target_group[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "redirect" {
  count             = var.create_elb ? 1 : 0
  load_balancer_arn = module.alb[0].arn
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
