
    module "amazon_mq" {
      source         = "./modules/amazon_mq"
      env            = var.env
      service        = var.kafka_service_name
      region         = var.region
      mq_settings    = var.mq_settings[var.env]
      mq_credentials = var.mq_credentials
      subnet_ids     = var.mq_subnet_ids[var.env] # Below are optional. We have set sensible defaults
      tags           = var.tags[var.env]
      sns_topic      = var.sns_topic[var.env]
    }
