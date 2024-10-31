output "arn" {
  value = aws_lambda_function.lambda.arn
}


output "name" {
  value = aws_lambda_function.lambda.function_name
}

/* 
output "log_group_arn" {
  value = aws_cloudwatch_log_group.lambda_logs.arn
} */
