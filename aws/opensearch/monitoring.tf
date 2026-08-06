resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${var.env}-${var.service}-opensearch-cluster"
  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "height" : 6,
          "width" : 6,
          "y" : 6,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/ES", "ClusterStatus.green", "DomainName", "${aws_opensearch_domain.os.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 60,
            "stat" : "Maximum"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 6,
          "x" : 6,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/ES", "ClusterStatus.yellow", "DomainName", "${aws_opensearch_domain.os.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 60,
            "stat" : "Maximum"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 6,
          "x" : 12,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/ES", "ClusterStatus.red", "DomainName", "${aws_opensearch_domain.os.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 60,
            "stat" : "Maximum"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 6,
          "x" : 18,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/ES", "Nodes", "DomainName", "${aws_opensearch_domain.os.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}"]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "stat" : "Minimum",
            "period" : 60
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
              ["AWS/ES", "CPUUtilization", "DomainName", "${aws_opensearch_domain.os.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "stat" : "Maximum",
            "period" : 60,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "limit",
                  "value" : 90
                }
              ]
            }
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
              ["AWS/ES", "FreeStorageSpace", "DomainName", "${aws_opensearch_domain.os.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "period" : 60,
            "stat" : "Minimum",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "limit",
                  "value" : 100000
                }
              ]
            }
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
              ["AWS/ES", "JVMMemoryPressure", "DomainName", "${aws_opensearch_domain.os.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "stat" : "Maximum",
            "period" : 60,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "limit",
                  "value" : 90
                }
              ]
            }
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
              ["AWS/ES", "ClusterUsedSpace", "DomainName", "${aws_opensearch_domain.os.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}"]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.region}",
            "stat" : "Maximum",
            "period" : 60
          }
        }
      ]
    }
  )
}

# FreeStorageSpace

resource "aws_cloudwatch_metric_alarm" "FreeStorageSpace" {
  alarm_name          = "${var.env}-${var.service}-Opensearch-FreeStorageSpace"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "15"
  threshold           = var.storage_alarm_threshold
  alarm_description   = "This alarm monitors for OpenSearch free storage space dropping below ${var.storage_alarm_threshold}% of the per-node EBS volume size"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  metric_query {
    id          = "free_pct"
    label       = "FreeStorageSpacePercentage"
    expression  = "(free_mb / total_mb) * 100"
    return_data = true
  }

  metric_query {
    id = "free_mb"

    metric {
      metric_name = "FreeStorageSpace"
      namespace   = "AWS/ES"
      period      = "60"
      stat        = "Minimum"

      dimensions = {
        DomainName = aws_opensearch_domain.os.domain_name
        ClientId   = data.aws_caller_identity.current.account_id
      }
    }
  }

  metric_query {
    id         = "total_mb"
    expression = var.ebs_options["volume_size"] * 1024
  }
}

# JVMMemoryPressure

resource "aws_cloudwatch_metric_alarm" "JVMMemoryPressure" {
  alarm_name          = "${var.env}-${var.service}-Opensearch-JVMMemoryPressure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "15"
  metric_name         = "JVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This alarm monitors for OpenSearch JVMMemoryPressure"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = aws_opensearch_domain.os.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# CPUUtilization

resource "aws_cloudwatch_metric_alarm" "CPUUtilization" {
  alarm_name          = "${var.env}-${var.service}-Opensearch-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "15"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This alarm monitors for OpenSearch high CPUUtilization"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = aws_opensearch_domain.os.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# ClusterStatus.green

resource "aws_cloudwatch_metric_alarm" "ClusterStatus_green" {
  alarm_name          = "${var.env}-${var.service}-Opensearch-ClusterStatus.green"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "15"
  metric_name         = "ClusterStatus.green"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Minimum"
  threshold           = 0
  alarm_description   = "This alarm monitors for when OpenSearch cluster status is not green"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = aws_opensearch_domain.os.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}
