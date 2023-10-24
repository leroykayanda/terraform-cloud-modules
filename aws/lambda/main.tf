
resource "aws_lambda_function" "lambda" {

  function_name    = "${var.env}-${var.service}"
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)
  role             = var.iam_role
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size

  environment {
    variables = var.env_variables
  }

  ephemeral_storage {
    size = var.ephemeral_storage
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 30

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

/* 
resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${var.env}-${var.microservice_name}-Lambda"

  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "type" : "metric",
          "x" : 0,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/Lambda", "Errors", "FunctionName", aws_lambda_function.lambda_function.function_name, { "region" : "${var.region}" }]
            ],
            "region" : "${var.region}",
            "period" : 300
          }
        },
        {
          "type" : "metric",
          "x" : 6,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.lambda_function.function_name, { "region" : "${var.region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 300,
            "stat" : "Sum"
          }
        },
        {
          "type" : "metric",
          "x" : 12,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/Lambda", "Duration", "FunctionName", aws_lambda_function.lambda_function.function_name, { "region" : "${var.region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 300,
            "stat" : "Maximum"
          }
        },
        {
          "type" : "metric",
          "x" : 18,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/Lambda", "ConcurrentExecutions", "FunctionName", aws_lambda_function.lambda_function.function_name, { "region" : "${var.region}" }],
              [".", "Throttles", ".", "."]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 300,
            "stat" : "Sum"
          }
        },
        {
          "type" : "log",
          "x" : 0,
          "y" : 6,
          "width" : 24,
          "height" : 10,
          "properties" : {
            "query" : "SOURCE '${aws_cloudwatch_log_group.lambda_logs.name}' | fields @timestamp, @message\n| sort @timestamp desc",
            "region" : "${var.region}",
            "stacked" : false,
            "view" : "table"
          }
        }
      ]
    }
  )
}
 */
