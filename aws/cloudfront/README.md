

    module "cloudfront" {
      source                       = "./modules/cloudfront"
      env                          = var.world
      service                      = var.ecs_service_name
      acm_certificate_arn          = var.acm_certificate_arn[var.world]
      origin                       = local.origin[var.world]
      ordered_cache_behavior       = local.ordered_cache_behavior[var.world]
      create_origin_access_control = var.create_origin_access_control
      sns_topic                    = var.sns_topic[var.world]
      aliases                      = var.aliases[var.world]
      default_cache_behavior       = local.default_cache_behavior[var.world]
      logs_bucket                  = module.s3_website_logs_bucket.s3_bucket_bucket_domain_name
      enabled                      = var.enabled
      http_version                 = var.http_version
      is_ipv6_enabled              = var.is_ipv6_enabled
      region                       = var.region
      locations                    = var.locations
      minimum_protocol_version     = var.minimum_protocol_version
      ssl_support_method           = var.ssl_support_method
      default_root_object          = var.default_root_object
      logging_config               = var.logging_config
      price_class                  = var.price_class
      wait_for_deployment          = var.wait_for_deployment
      tags                         = var.tags[var.world]
    }
