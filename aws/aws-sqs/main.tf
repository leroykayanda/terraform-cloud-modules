resource "aws_sqs_queue" "main_sqs" {
  name                       = "${var.env}-${var.microservice_name}"
  delay_seconds              = var.delay_seconds
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = 20
  sqs_managed_sse_enabled    = true
  visibility_timeout_seconds = var.visibility_timeout_seconds
  max_message_size           = var.max_message_size

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          "AWS" : data.aws_caller_identity.current.account_id
        }
      },
    ]
  })

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_sqs_queue" "dlq" {
  name                       = "${var.env}-${var.microservice_name}-DLQ"
  delay_seconds              = 0
  message_retention_seconds  = 1209600 #14 days
  receive_wait_time_seconds  = 20
  sqs_managed_sse_enabled    = true
  visibility_timeout_seconds = 300

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:SendMessage"
        ]
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          "AWS" : data.aws_caller_identity.current.account_id
        }
      },
    ]
  })

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "ApproximateNumberOfMessagesVisible" {
  alarm_name          = "${var.env}-${var.microservice_name}-High-No.-Of-Msgs-In-Queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "50"
  alarm_description   = "This alarm monitors for when there are too many unprocessed message in the queue"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    QueueName = aws_sqs_queue.main_sqs.name
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "ApproximateAgeOfOldestMessage" {
  alarm_name          = "${var.env}-${var.microservice_name}-Old-Unprocessed-Messages-In-Queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "600"
  alarm_description   = "This alarm monitors for when messages in the queue are not being processed quickly enough"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    QueueName = aws_sqs_queue.main_sqs.name
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "NumberOfMessagesSent" {
  alarm_name          = "${var.env}-${var.microservice_name}-Unprocessed-Msg-Sent-To-DLQ"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NumberOfMessagesSent"
  namespace           = "AWS/SQS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "This alarm monitors for when a message is sent to the Dead Letter Queue"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    QueueName = aws_sqs_queue.dlq.name
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}
