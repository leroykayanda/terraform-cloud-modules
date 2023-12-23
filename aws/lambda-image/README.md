

    module "lambda" {
      source            = "modules/aws-lambda?ref=v1.1.98"
      env               = var.env
      team              = var.team
      microservice_name = "abc"
      iam_role          = aws_iam_role.iam_for_lambda.arn
      image_uri         = "${module.ecr_repo_lambda.repository_url}:${local.lambda_image_tag}"
      timeout           = var.lambda_timeout
      memory_size       = var.lambda_memory_size
      env_variables     = local.lambda_env_variables
      region            = var.region #below are optional
      subnets = var.subnets
      security_group_id = var.security_group_id
      needs_vpc = var.needs_vpc
    }


