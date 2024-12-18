resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${var.env}-${var.service}-elasticsearch-cluster"
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
              ["AWS/ES", "ClusterStatus.green", "DomainName", "${aws_elasticsearch_domain.es.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
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
              ["AWS/ES", "ClusterStatus.yellow", "DomainName", "${aws_elasticsearch_domain.es.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
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
              ["AWS/ES", "ClusterStatus.red", "DomainName", "${aws_elasticsearch_domain.es.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
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
              ["AWS/ES", "Nodes", "DomainName", "${aws_elasticsearch_domain.es.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}"]
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
              ["AWS/ES", "CPUUtilization", "DomainName", "${aws_elasticsearch_domain.es.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
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
              ["AWS/ES", "FreeStorageSpace", "DomainName", "${aws_elasticsearch_domain.es.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
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
                  "value" : 20000
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
              ["AWS/ES", "JVMMemoryPressure", "DomainName", "${aws_elasticsearch_domain.es.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}", { "region" : "${var.region}" }]
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
              ["AWS/ES", "ClusterUsedSpace", "DomainName", "${aws_elasticsearch_domain.es.domain_name}", "ClientId", "${data.aws_caller_identity.current.account_id}"]
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
  alarm_name          = "${var.env}-${var.service}-Elasticsearch-FreeStorageSpace"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Minimum"
  threshold           = 20000
  alarm_description   = "This alarm monitors for ES low storage space"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = aws_elasticsearch_domain.es.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# JVMMemoryPressure

resource "aws_cloudwatch_metric_alarm" "JVMMemoryPressure" {
  alarm_name          = "${var.env}-${var.service}-Elasticsearch-JVMMemoryPressure"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "JVMMemoryPressure"
  namespace           = "AWS/ES"
  period              = "300"
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This alarm monitors for ES JVMMemoryPressure"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = aws_elasticsearch_domain.es.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# CPUUtilization

resource "aws_cloudwatch_metric_alarm" "CPUUtilization" {
  alarm_name          = "${var.env}-${var.service}-Elasticsearch-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ES"
  period              = "300"
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This alarm monitors for ES high CPUUtilization"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = aws_elasticsearch_domain.es.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}

# ClusterStatus.green

resource "aws_cloudwatch_metric_alarm" "ClusterStatus_green" {
  alarm_name          = "${var.env}-${var.service}-Elasticsearch-ClusterStatus.green"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ClusterStatus.green"
  namespace           = "AWS/ES"
  period              = "60"
  statistic           = "Minimum"
  threshold           = 0
  alarm_description   = "This alarm monitors for when ES cluster status is not green"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DomainName = aws_elasticsearch_domain.es.domain_name
    ClientId   = data.aws_caller_identity.current.account_id
  }
}
