resource "aws_cloudwatch_dashboard" "dash" {
  count          = var.enable_monitoring ? 1 : 0
  dashboard_name = "${var.env}-${var.service}-Lambda"

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
            "period" : 60
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
            "period" : 60,
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
            "period" : 60,
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
            "period" : 60,
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

# Errors

resource "aws_cloudwatch_metric_alarm" "errors" {
  count               = var.enable_monitoring ? 1 : 0
  alarm_name          = "${var.env}-${var.service}-Lambda-Error"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "This alarm monitors lambda errors"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    FunctionName = aws_lambda_function.lambda_function.function_name
  }
}
