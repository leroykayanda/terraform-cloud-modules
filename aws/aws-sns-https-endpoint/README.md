    module "sns_https_endpoint_file_processing_result" {
      source   = "git@github.com:abc/terraform-modules.git//modules/aws-sns-https-endpoint?ref=v1.1.90"
      env      = var.env
      team     = var.team
      service  = var.service
      dlq_arn  = var.dlq_arn
      endpoint = var.endpoint
    }
