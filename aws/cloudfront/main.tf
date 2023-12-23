data "aws_cloudfront_cache_policy" "policy" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "all" {
  name = "Managed-AllViewer"
}

resource "aws_cloudfront_distribution" "cf" {
  origin {
    domain_name = var.lb_dns_name
    origin_id   = var.comment

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = false
  comment         = var.comment
  aliases         = var.aliases

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = var.comment
    cache_policy_id          = data.aws_cloudfront_cache_policy.policy.id
    viewer_protocol_policy   = "redirect-to-https"
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}
