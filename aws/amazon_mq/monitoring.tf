resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${var.env}-${var.service}-AmazonMQ-Cluster"
  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "type" : "metric",
          "x" : 18,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/AmazonMQ", "QueueCount", "Broker", aws_mq_broker.mq.broker_name, { "region" : var.region }]
            ],
            "view" : "singleValue",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 300,
            "sparkline" : true
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/AmazonMQ", "MessageCount", "Broker", aws_mq_broker.mq.broker_name]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
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
              ["AWS/AmazonMQ", "MessageReadyCount", "Broker", aws_mq_broker.mq.broker_name, { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60
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
              ["AWS/AmazonMQ", "MessageUnacknowledgedCount", "Broker", aws_mq_broker.mq.broker_name, { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Minimum",
            "period" : 60
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 6,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [{ "expression" : "m1/60", "label" : "PublishRate", "id" : "e1" }],
              ["AWS/AmazonMQ", "PublishRate", "Broker", aws_mq_broker.mq.broker_name, { "region" : var.region, "id" : "m1", "visible" : false }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "PublishRate/s"
          }
        },
        {
          "type" : "metric",
          "x" : 6,
          "y" : 6,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [{ "expression" : "m1/60", "label" : "AckRate", "id" : "e1" }],
              ["AWS/AmazonMQ", "AckRate", "Broker", aws_mq_broker.mq.broker_name, { "visible" : false, "id" : "m1", "period" : 60 }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 300,
            "title" : "AckRate/s"
          }
        },
        {
          "type" : "metric",
          "x" : 18,
          "y" : 6,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/AmazonMQ", "SystemCpuUtilization", "Broker", aws_mq_broker.mq.broker_name]
            ],
            "region" : var.region,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "usage",
                  "value" : 90
                }
              ]
            }
          }
        },
        {
          "type" : "metric",
          "x" : 12,
          "y" : 6,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [{ "expression" : "m2/m1*100", "label" : "MemoryUsage", "id" : "e1", "region" : var.region }],
              ["AWS/AmazonMQ", "RabbitMQMemLimit", "Broker", aws_mq_broker.mq.broker_name, { "visible" : false, "id" : "m1", "region" : var.region }],
              [".", "RabbitMQMemUsed", ".", ".", { "visible" : false, "id" : "m2", "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "MemoryUsage",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "usage",
                  "value" : 90
                }
              ]
            }
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 12,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "metrics" : [
              ["AWS/AmazonMQ", "RabbitMQDiskFree", "Broker", aws_mq_broker.mq.broker_name, { "region" : var.region }]
            ],
            "title" : "RabbitMQDiskFree",
            "period" : 300,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "disk_left",
                  "value" : 10000000000
                }
              ]
            }
          }
        }
      ]
    }
  )
}

# Unacknowledged messages
resource "aws_cloudwatch_metric_alarm" "unacknowledged_messages" {
  alarm_name          = "${var.env}-${var.service}-AmazonMQ-high-no-of-unacknowledged-messages"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MessageUnacknowledgedCount"
  namespace           = "AWS/AmazonMQ"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  alarm_description   = "This alarm monitors for when consumers are not acknowledging messages"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    Broker = aws_mq_broker.mq.broker_name
  }
}

# Ready messages
resource "aws_cloudwatch_metric_alarm" "ready_messages" {
  alarm_name          = "${var.env}-${var.service}-AmazonMQ-high-no-of-unprocessed-messages"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MessageReadyCount"
  namespace           = "AWS/AmazonMQ"
  period              = "300"
  statistic           = "Average"
  threshold           = var.mq_settings["ready_messages_alarm_threshold"]
  alarm_description   = "This alarm monitors for when messages are not being consumed from the queue"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    Broker = aws_mq_broker.mq.broker_name
  }
}

# Cluster Memory
resource "aws_cloudwatch_metric_alarm" "memory" {
  alarm_name          = "${var.env}-${var.service}-AmazonMQ-High-Memory-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 90
  alarm_description   = "This alarm monitors for high MQ memory usage"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  metric_query {
    id          = "e1"
    expression  = "m1/m2*100"
    label       = "MemoryUsage"
    return_data = "true"
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "RabbitMQMemLimit"
      namespace   = "AWS/AmazonMQ"
      period      = 300
      stat        = "Average"

      dimensions = {
        Broker = aws_mq_broker.mq.broker_name
      }
    }
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RabbitMQMemUsed"
      namespace   = "AWS/AmazonMQ"
      period      = 300
      stat        = "Average"

      dimensions = {
        Broker = aws_mq_broker.mq.broker_name
      }
    }
  }

}

# Cluster CPU
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "${var.env}-${var.service}-AmazonMQ-High-CPU-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "SystemCpuUtilization"
  namespace           = "AWS/AmazonMQ"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "This alarm monitors for high MQ CPU usage"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    Broker = aws_mq_broker.mq.broker_name
  }
}

# Disk Free
resource "aws_cloudwatch_metric_alarm" "disk" {
  alarm_name          = "${var.env}-${var.service}-AmazonMQ-Low-Free-Disk-Space"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RabbitMQDiskFree"
  namespace           = "AWS/AmazonMQ"
  period              = "300"
  statistic           = "Average"
  threshold           = var.mq_settings["disk_space_alarm_threshold"]
  alarm_description   = "This alarm monitors for low free disk space"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    Broker = aws_mq_broker.mq.broker_name
  }
}
