resource "aws_iam_role" "lambda_iam_role_errors" {
  name = "${var.env}-${var.microservice_name}-errors"
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
  role       = aws_iam_role.lambda_iam_role_errors.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "error_monitoring" {

  function_name    = "${var.env}-${var.microservice_name}-error-monitoring"
  filename         = "${path.module}/monitoring-lambda.py.zip"
  source_code_hash = filebase64sha256("${path.module}/monitoring-lambda.py.zip")
  role             = aws_iam_role.lambda_iam_role_errors.arn
  handler          = "monitoring-lambda.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60

  environment {
    variables = {
      team     = var.team
      GenieKey = var.GenieKey
      service  = "${var.env}-${var.microservice_name}"
    }
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs_errors" {
  name              = "/aws/lambda/${aws_lambda_function.error_monitoring.function_name}"
  retention_in_days = 30

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
  depends_on      = [aws_lambda_permission.lambda_permission_errors]
  name            = "error-logs"
  log_group_name  = var.log_group_name
  filter_pattern  = var.filter_pattern
  destination_arn = aws_lambda_function.error_monitoring.arn
}

resource "aws_lambda_permission" "lambda_permission_errors" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.error_monitoring.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${var.log_group_arn}:*"
}
