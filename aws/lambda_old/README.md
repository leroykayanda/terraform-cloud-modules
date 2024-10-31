

    module "lambda" {
      source            = "modules/aws-lambda?ref=v1.1.98"
      env               = var.env
      team              = var.team
      service           = "abc"
      iam_role          = aws_iam_role.iam_for_lambda.arn
      image_uri         = "${module.ecr_repo_lambda.repository_url}:${local.lambda_image_tag}"
      timeout           = var.lambda_timeout
      filename          = var.filename
      handler           = var.handler
      runtime           = var.runtime #optional variables
      env_variables     = local.lambda_env_variables
      memory_size       = var.lambda_memory_size
      ephemeral_storage = var.ephemeral_storage
    }