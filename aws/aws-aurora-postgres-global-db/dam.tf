resource "aws_rds_cluster_parameter_group" "db_parameter_group" {
  name   = "${var.env}-${var.microservice_name}-cluster"
  family = var.parameter_group_family

  parameter {
    name  = "pgaudit.log"
    value = "DDL,ROLE"
  }

  parameter {
    name  = "pgaudit.role"
    value = "rds_pgaudit"
  }

  parameter {
    name  = "work_mem"
    value = 716800
  }

  parameter {
    name  = "log_temp_files"
    value = 2048
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pgaudit"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.env}-${var.microservice_name}-instance"
  family = var.parameter_group_family

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

resource "aws_iam_role" "dam_role" {
  name = "${var.env}-${var.microservice_name}-errors-lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment_lambda_errors" {
  role       = aws_iam_role.dam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda_function" {

  function_name    = "${var.env}-${var.microservice_name}-dam"
  filename         = "${path.module}/monitoring-lambda.py.zip"
  source_code_hash = filebase64sha256("${path.module}/monitoring-lambda.py.zip")
  role             = aws_iam_role.dam_role.arn
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
  depends_on      = [aws_lambda_permission.lambda_permission, aws_rds_cluster.aurora]
  name            = "dam-alerts"
  log_group_name  = "/aws/rds/cluster/${var.env}-${var.microservice_name}/postgresql"
  filter_pattern  = "?\"ROLE\" ?\"DDL\""
  destination_arn = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/rds/cluster/${var.env}-${var.microservice_name}/postgresql:*"
}
