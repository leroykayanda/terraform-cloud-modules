    module "lambda" {
      source                   = "./modules/lambda"
      env                      = var.env
      iam_role                 = aws_iam_role.lambda_execution_role.arn
      service                  = var.service # Below are optional
      tags                     = var.tags[var.env]
      image_uri                = local.container_image
      memory_size              = var.memory_size
      region                   = var.region
      sns_topic                = var.sns_topic[var.env]
      ephemeral_storage        = var.ephemeral_storage
      cloudwatch_log_retention = var.cloudwatch_log_retention
      package_type             = var.package_type
      timeout                  = var.timeout
      env_variables            = var.env_variables
      subnets                  = var.subnets
      security_group_id        = var.security_group_id
      needs_vpc                = var.needs_vpc
    }
