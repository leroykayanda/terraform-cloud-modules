resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.cloudwatch_log_retention
  tags              = var.tags
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.env}-${var.service}"
  package_type  = var.package_type
  role          = var.iam_role
  image_uri     = var.image_uri
  timeout       = var.timeout
  memory_size   = var.memory_size
  tags          = var.tags

  dynamic "vpc_config" {
    for_each = var.needs_vpc ? [1] : []
    content {
      subnet_ids         = var.subnets
      security_group_ids = [var.security_group_id]
    }
  }

  environment {
    variables = var.env_variables
  }

  ephemeral_storage {
    size = var.ephemeral_storage
  }

  dynamic "image_config" {
    for_each = length(var.command) > 0 ? [1] : []
    content {
      command = var.command
    }
  }

}
