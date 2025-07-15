resource "aws_cloudwatch_metric_alarm" "approximate_number_of_messages_visible" {
  alarm_name          = "${var.env}-${var.service}-High-No-Of-Msgs-In-Queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "15"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_thresholds["approximate_number_of_messages_visible"]
  alarm_description   = "This alarm monitors for when there are too many unprocessed message in the queue"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    QueueName = aws_sqs_queue.queue.name
  }
}

resource "aws_cloudwatch_metric_alarm" "approximate_age_of_oldest_message" {
  alarm_name          = "${var.env}-${var.service}-Old-Unprocessed-Messages-In-Queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "15"
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_thresholds["approximate_age_of_oldest_message"]
  alarm_description   = "This alarm monitors for when messages in the queue are not being processed quickly enough"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    QueueName = aws_sqs_queue.queue.name
  }
}
