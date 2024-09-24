resource "aws_cloudfront_origin_access_control" "oac" {
  count                             = var.create_origin_access_control ? 1 : 0
  name                              = "${var.env}-${var.service}"
  description                       = "${var.env}-${var.service}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cf" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = "${var.env}-${var.service}"
  aliases             = var.aliases
  default_root_object = var.default_root_object
  http_version        = var.http_version
  price_class         = var.price_class
  wait_for_deployment = var.wait_for_deployment
  tags                = var.tags

  dynamic "origin" {
    for_each = var.origin

    content {
      domain_name              = origin.value.domain_name
      origin_access_control_id = aws_cloudfront_origin_access_control.oac[0].id
      origin_id                = origin.value.origin_id
    }
  }

  default_cache_behavior {
    allowed_methods        = var.default_cache_behavior["allowed_methods"]
    cached_methods         = var.default_cache_behavior["cached_methods"]
    target_origin_id       = var.default_cache_behavior["target_origin_id"]
    cache_policy_id        = var.default_cache_behavior["cache_policy_id"]
    viewer_protocol_policy = var.default_cache_behavior["viewer_protocol_policy"]
    compress               = var.default_cache_behavior["compress"]
    default_ttl            = var.default_cache_behavior["default_ttl"]
    min_ttl                = var.default_cache_behavior["min_ttl"]
    max_ttl                = var.default_cache_behavior["max_ttl"]
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior

    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      cache_policy_id        = ordered_cache_behavior.value.cache_policy_id
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      compress               = ordered_cache_behavior.value.compress
      default_ttl            = ordered_cache_behavior.value.default_ttl
      min_ttl                = ordered_cache_behavior.value.min_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.locations
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = var.minimum_protocol_version
    ssl_support_method       = var.ssl_support_method
  }

  logging_config {
    include_cookies = var.logging_config["include_cookies"]
    bucket          = var.logs_bucket
    prefix          = var.logging_config["prefix"]
  }
}
