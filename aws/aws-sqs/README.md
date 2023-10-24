    module "sqs_file_cleaning_trigger" {
      source                     = "git@github.com:abc/terraform-modules.git//modules/aws-s3-bucket?ref=v1.1.85"
      env                        = var.env
      team                       = var.team
      microservice_name          = "${var.env}-recon-file-processing-trigger"
      sns_topic                  = local.recon_sns_topic
      visibility_timeout_seconds = var.visibility_timeout_seconds
      message_retention_seconds  = var.message_retention_seconds #below are optional
      delay_seconds              = var.delay_seconds
      max_message_size           = var.max_message_size
    }
