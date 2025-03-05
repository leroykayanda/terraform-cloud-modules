resource "aws_security_group" "sg" {
  name        = "${var.env}-${var.service}"
  description = "${var.env}-${var.service}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.env}-${var.service}"
  }
}

module "access_logs_bucket" {
  count                          = var.create_access_logs_bucket && !var.use_access_logs_bucket_prefix ? 1 : 0
  source                         = "terraform-aws-modules/s3-bucket/aws"
  bucket                         = "${var.company_name}-${var.env}-${var.service}-access-logs"
  acl                            = "log-delivery-write"
  force_destroy                  = true
  control_object_ownership       = true
  object_ownership               = "ObjectWriter"
  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true
  tags                           = var.tags
  lifecycle_rule = [
    {
      id      = "expire_old_logs"
      enabled = true

      expiration = {
        days = var.elb_access_log_expiration
      }
    }
  ]
}

resource "aws_lb" "lb" {
  name                       = "${var.env}-${var.service}"
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [aws_security_group.sg.id]
  subnets                    = var.subnets
  enable_deletion_protection = false
  tags                       = var.tags
  client_keep_alive          = var.client_keep_alive
  enable_http2               = var.enable_http2

  dynamic "access_logs" {
    for_each = var.create_access_logs_bucket ? [1] : []
    content {
      bucket  = var.existing_access_logs_bucket == "" ? module.access_logs_bucket[0].s3_bucket_id : var.existing_access_logs_bucket
      enabled = true
      prefix  = var.use_access_logs_bucket_prefix ? "${var.env}-${var.service}" : null
    }
  }
}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.lb.arn
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

resource "aws_lb_listener" "listener_443_fixed_response" {
  count             = var.target_group_details["create_target_group"] ? 0 : 1
  load_balancer_arn = aws_lb.lb.arn
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.ssl_policy
  tags              = var.tags

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener" "listener_443_forward" {
  count             = var.target_group_details["create_target_group"] ? 1 : 0
  load_balancer_arn = aws_lb.lb.arn
  protocol          = "HTTPS"
  port              = 443
  certificate_arn   = var.certificate_arn
  ssl_policy        = var.ssl_policy
  tags              = var.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[0].arn
  }
}

resource "aws_lb_target_group" "target_group" {
  count                = var.target_group_details["create_target_group"] ? 1 : 0
  name                 = "${var.env}-${var.service}"
  port                 = var.target_group_details["application_port"]
  protocol             = var.target_group_details["protocol"]
  target_type          = "instance"
  vpc_id               = var.vpc_id
  tags                 = var.tags
  deregistration_delay = var.target_group_details["deregistration_delay"]
  protocol_version     = var.target_group_details["protocol_version"]

  health_check {
    path                = var.target_group_details["health_check_path"]
    protocol            = var.target_group_details["health_check_protocol"]
    matcher             = var.target_group_details["health_check_matcher"]
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
  }
}
