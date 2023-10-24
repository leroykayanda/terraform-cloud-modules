resource "aws_rds_cluster_parameter_group" "db_parameter_group" {
  name   = "${var.env}-${var.microservice_name}-cluster"
  family = var.family

  parameter {
    name  = "pgaudit.log"
    value = "DDL,ROLE"
  }

  parameter {
    name  = "pgaudit.role"
    value = "rds_pgaudit"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pgaudit"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.env}-${var.microservice_name}-instance"
  family = var.family

  parameter {
    name  = "pgaudit.log"
    value = "DDL,ROLE"
  }

  parameter {
    name  = "pgaudit.role"
    value = "rds_pgaudit"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pgaudit"
    apply_method = "pending-reboot"
  }
}

resource "aws_lambda_function" "lambda_function" {

  function_name = "${var.env}-${var.microservice_name}-dam"

  filename         = "monitoring-lambda.py.zip"
  source_code_hash = filebase64sha256("monitoring-lambda.py.zip")
  role             = var.lambda_iam_role
  handler          = "monitoring-lambda.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

  environment {
    variables = {
      env          = var.env
      team         = var.team
      GenieKey     = var.GenieKey
      microservice = var.microservice_name
    }
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }

}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = 30

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
  depends_on      = [aws_lambda_permission.lambda_permission]
  name            = "dam-alerts"
  log_group_name  = var.log_group_name
  filter_pattern  = "?\"ROLE\" ?\"DDL\""
  destination_arn = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${var.log_group_arn}:*"
}

