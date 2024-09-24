variable "env" {
  type        = string
  description = "Deployment environment e.g prod, dev"
}

variable "service" {
  type        = string
  description = "Name of the service"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the AWS Certificate Manager certificate that you wish to use with this distribution. The ACM certificate must be in US-EAST-1."
}

variable "origin" {
  type        = map(map(string))
  description = "One or more origins for this distribution"
  default = {
    s3-bucket = {
      domain_name = ""
      origin_id   = "s3"
    }
  }
}

variable "ordered_cache_behavior" {
  type        = any
  description = "Ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence."
  default = {
    s3 = {
      path_pattern           = "/api"
      allowed_methods        = ["GET", "HEAD"]
      cached_methods         = ["GET", "HEAD"]
      target_origin_id       = "s3"
      cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
      viewer_protocol_policy = "redirect-to-https"
      compress               = false
      default_ttl            = null
      min_ttl                = null
      max_ttl                = null
    }
  }
}

variable "create_origin_access_control" {
  description = "Controls if CloudFront origin access control should be created"
  type        = bool
  default     = false
}

# Optional variables. We have set sensible defaults.

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content."
  type        = bool
  default     = true
}

variable "default_cache_behavior" {
  type        = any
  description = "Default cache behavior for this distribution (maximum one)"
  default = {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
    compress               = false
    default_ttl            = null
    min_ttl                = null
    max_ttl                = null
  }
}

variable "http_version" {
  type        = string
  description = "HTTP versions to support on the distribution."
  default     = "http2and3"
}

variable "tags" {
  type        = map(string)
  description = "Used to tag resources"
  default     = {}
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution."
  type        = bool
  default     = false
}

variable "aliases" {
  type        = list(string)
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  default     = []
}

variable "sns_topic" {
  type        = string
  description = "For alarm notifications"
  default     = null
}

variable "restriction_type" {
  type        = string
  description = "Method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist."
  default     = "none"
}

variable "locations" {
  type        = list(string)
  description = "ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content (whitelist) or not distribute your content (blacklist). If the type is specified as none an empty array can be used."
  default     = []
}

variable "minimum_protocol_version" {
  type        = string
  description = "Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
  default     = "TLSv1.2_2021"
}

variable "ssl_support_method" {
  type        = string
  description = "Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections."
  default     = "sni-only"
}

variable "default_root_object" {
  type        = string
  description = "Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  default     = "index.html"
}

variable "logging_config" {
  type        = map(string)
  description = "The logging configuration that controls how logs are written to your distribution"
  default = {
    include_cookies = false
    prefix          = null
  }
}

variable "logs_bucket" {
  type        = string
  description = "S3 bucket domain name"
  default     = null
}

variable "price_class" {
  type        = string
  description = "Price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  default     = "PriceClass_All"
}

variable "wait_for_deployment" {
  type        = bool
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed"
  default     = true
}
