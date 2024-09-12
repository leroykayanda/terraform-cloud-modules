resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${var.env}-${var.service}-kafka-cluster"
  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 12,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              [{ "expression" : "SEARCH('{AWS/Kafka, \"Cluster Name\", Topic, \"Broker ID\"} MetricName=\"BytesInPerSec\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Average')", "label" : "BytesInPerSec", "id" : "e1", "region" : var.region, "period" : 60 }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "Bytes IN/s"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 18,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              [{ "expression" : "SEARCH('{AWS/Kafka, \"Cluster Name\", Topic, \"Broker ID\"} MetricName=\"BytesOutPerSec\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Average')", "label" : "BytesOutPerSec", "id" : "e1", "region" : var.region, "period" : 60 }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "Bytes OUT/s"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 6,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              [{ "expression" : "SEARCH('{AWS/Kafka, \"Cluster Name\", \"Client Authentication\"} MetricName=\"ClientConnectionCount\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Maximum')", "label" : "ClientConnectionCount", "id" : "e1", "region" : var.region, "period" : 60 }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "Client Connection Count By Auth Method"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              [{ "expression" : "SEARCH('{AWS/Kafka, \"Cluster Name\"} MetricName=\"ClientConnectionCount\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Maximum')", "label" : "", "id" : "e1", "region" : var.region, "period" : 60 }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "Client Connection Count Total"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 6,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              [{ "expression" : "SEARCH('{AWS/Kafka, \"Cluster Name\", \"Broker ID\"} MetricName=\"CpuIdle\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Average')", "label" : "CpuIdle", "id" : "e1", "region" : var.region, "period" : 60 }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "CPU Idle",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "idle",
                  "value" : 10
                }
              ]
            }
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 12,
          "x" : 6,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/Kafka", "GlobalTopicCount", "Cluster Name", "${var.env}-${var.service}", { "region" : var.region }]
            ],
            "sparkline" : true,
            "view" : "singleValue",
            "region" : var.region,
            "title" : "Global Topic Count",
            "period" : 300,
            "stat" : "Maximum"
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 12,
          "width" : 6,
          "height" : 7,
          "properties" : {
            "metrics" : [
              [{ "expression" : "SEARCH('{AWS/Kafka, \"Cluster Name\", Topic, \"Consumer Group\"} MetricName=\"MaxOffsetLag\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Maximum')", "label" : "MaxOffsetLag", "id" : "e1", "period" : 60, "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "MaxOffsetLag"
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
              [{ "expression" : "(SEARCH('{AWS/Kafka, \"Cluster Name\", \"Broker ID\"} MetricName=\"MemoryUsed\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Average')/(${var.kafka_settings["broker_memory_in_gb"]}*1073741824))*100", "label" : "MemoryUsed", "id" : "e1", "period" : 60 }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "MemoryUsed",
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
          "x" : 18,
          "y" : 6,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [{ "expression" : "SEARCH('{AWS/Kafka, \"Cluster Name\", \"Broker ID\", Topic} MetricName=\"MessagesInPerSec\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Average')", "label" : "MessagesInPerSec", "id" : "e1", "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 300,
            "title" : "MessagesInPerSec"
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
              [{ "expression" : "SEARCH('{AWS/Kafka, \"Cluster Name\", \"Broker ID\"} MetricName=\"KafkaDataLogsDiskUsed\" \"Cluster Name\"=\"${var.env}-${var.service}\"', 'Average')", "label" : "KafkaDataLogsDiskUsed", "id" : "e1" }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "stat" : "Average",
            "period" : 300,
            "title" : "KafkaDataLogsDiskUsed",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "usage",
                  "value" : 80
                }
              ]
            }
          }
        }
      ]
    }
  )
}

# Idle cpu
resource "aws_cloudwatch_metric_alarm" "idle_cpu" {
  count               = var.kafka_settings["number_of_broker_nodes"]
  alarm_name          = "${var.env}-${var.service}-High-CPU-Usage-Kafka-Broker-${count.index + 1}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CpuIdle"
  namespace           = "AWS/Kafka"
  period              = "300"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "This alarm monitors low kafka idle CPU"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    "Cluster Name" = "${var.env}-${var.service}"
    "Broker ID"    = count.index + 1
  }
}

# Memory usage
resource "aws_cloudwatch_metric_alarm" "memory" {
  count               = var.kafka_settings["number_of_broker_nodes"]
  alarm_name          = "${var.env}-${var.service}-High-Memory-Usage-Kafka-Broker-${count.index + 1}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 90
  alarm_description   = "This alarm monitors high kafka memory usage"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  metric_query {
    id          = "e1"
    expression  = "m1/(${var.kafka_settings["broker_memory_in_gb"]}*1073741824)*100"
    label       = "MemoryUsed"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "MemoryUsed"
      namespace   = "AWS/Kafka"
      period      = 300
      stat        = "Average"

      dimensions = {
        "Cluster Name" = "${var.env}-${var.service}"
        "Broker ID"    = count.index + 1
      }
    }
  }
}

# Disk used
resource "aws_cloudwatch_metric_alarm" "disk" {
  count               = var.kafka_settings["number_of_broker_nodes"]
  alarm_name          = "${var.env}-${var.service}-Low-Disk-Capacity-Kafka-Broker-${count.index + 1}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "KafkaDataLogsDiskUsed"
  namespace           = "AWS/Kafka"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This alarm monitors low kafka disk capacity"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    "Cluster Name" = "${var.env}-${var.service}"
    "Broker ID"    = count.index + 1
  }
}
