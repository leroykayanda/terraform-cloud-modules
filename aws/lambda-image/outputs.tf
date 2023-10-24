output "lambda_arn" {
  value = aws_lambda_function.lambda_function.arn
}

output "lambda_name" {
  value = "${var.env}-${var.microservice_name}"
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.lambda_logs.arn
}