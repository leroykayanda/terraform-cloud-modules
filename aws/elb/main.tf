resource "aws_security_group" "sg" {
  name        = "${local.world}${local.separator}${var.service}"
  description = "${local.world}${local.separator}${var.service}"
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
    Name = "${local.world}${local.separator}${var.service}"
  }
}

module "access_logs_bucket" {
  count                          = var.create_access_logs_bucket ? 1 : 0
  source                         = "terraform-aws-modules/s3-bucket/aws"
  bucket                         = "${var.company_name}-${local.world}${local.separator}${var.service}-access-logs"
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
  name                       = "${local.world}${local.separator}${var.service}"
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
      bucket  = module.access_logs_bucket[0].s3_bucket_id
      enabled = true
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

resource "aws_lb_listener" "listener_443" {
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
      message_body = "Hello"
      status_code  = "200"
    }
  }
}
