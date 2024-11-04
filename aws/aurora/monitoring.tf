resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${var.env}-${var.service}-DB"
  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "type" : "metric",
          "x" : 0,
          "y" : 24,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/RDS", "TotalBackupStorageBilled", "DBClusterIdentifier", "${var.env}-${var.service}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "period" : 300,
            "stat" : "Average"
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
              ["AWS/RDS", "ServerlessDatabaseCapacity", "DBClusterIdentifier", "${var.env}-${var.service}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "ServerlessDatabaseCapacity"
          }
        },
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
              ["AWS/RDS", "ACUUtilization", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60, "region" : var.region }]
            ],
            "region" : var.region,
            "period" : 300,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "usage",
                  "value" : 90
                }
              ]
            },
            "title" : "ACUUtilization"
          }
        },
        {
          "type" : "metric",
          "x" : 18,
          "y" : 18,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "VolumeBytesUsed", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60 }]
            ],
            "region" : var.region
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
              [{ "expression" : "(m1+m2)/300", "label" : "IOPS", "id" : "e1" }],
              ["AWS/RDS", "VolumeReadIOPs", "DBClusterIdentifier", "${var.env}-${var.service}", { "region" : var.region, "id" : "m1", "visible" : false }],
              [".", "VolumeWriteIOPs", ".", ".", { "region" : var.region, "id" : "m2", "visible" : false }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "period" : 300,
            "stat" : "Average",
            "title" : "IOPS"
          }
        },
        {
          "type" : "metric",
          "x" : 6,
          "y" : 18,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "AuroraReplicaLag", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60 }]
            ],
            "region" : var.region
          }
        },
        {
          "type" : "metric",
          "x" : 12,
          "y" : 12,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "BufferCacheHitRatio", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60 }]
            ],
            "region" : var.region
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
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "CommitThroughput", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60 }]
            ],
            "region" : var.region
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 6,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "CPUUtilization", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60, "region" : var.region }]
            ],
            "region" : var.region,
            "period" : 300,
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
          "y" : 12,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/RDS", "DatabaseConnections", "DBClusterIdentifier", "${var.env}-${var.service}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "period" : 60,
            "stat" : "Sum"
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 18,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "Deadlocks", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60 }]
            ],
            "region" : var.region
          }
        },
        {
          "type" : "metric",
          "x" : 6,
          "y" : 12,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "DiskQueueDepth", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60 }]
            ],
            "region" : var.region
          }
        },
        {
          "type" : "metric",
          "x" : 18,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "FreeableMemory", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60, "region" : var.region }]
            ],
            "region" : var.region,
            "period" : 300,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "usage",
                  "value" : 2000000000
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
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "ReadLatency", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60 }]
            ],
            "region" : var.region
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
              ["AWS/RDS", "WriteLatency", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60, "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "title" : "WriteLatency",
            "period" : 300
          }
        },
        {
          "type" : "metric",
          "x" : 12,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "DBLoad", "DBInstanceIdentifier", aws_rds_cluster_instance.cluster_instances[0].id, { "period" : 60 }]
            ],
            "region" : var.region
          }
        },
        {
          "type" : "metric",
          "x" : 12,
          "y" : 18,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "SwapUsage", "DBClusterIdentifier", "${var.env}-${var.service}", { "period" : 60 }]
            ],
            "region" : var.region
          }
        }
      ]
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "acu_usage" {
  count               = var.aurora_settings["serverless_cluster"] ? 1 : 0
  alarm_name          = "${var.env}-${var.service}-DB-High-ACUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ACUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "This alarm monitors for high Aurora ACU usage"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora.cluster_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory" {
  alarm_name          = "${var.env}-${var.service}-DB-Low-Memory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.aurora_settings["freeable_memory_alarm_threshold"]
  alarm_description   = "This alarm monitors for low database memory"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora.cluster_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_CPUUtilization" {
  alarm_name          = "${var.env}-${var.service}-DB-High-CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "This alarm monitors for high database CPU"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora.cluster_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "read_latency" {
  alarm_name          = "${var.env}-${var.service}-DB-High-ReadLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This alarm monitors for high DB read latency"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora.cluster_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "write_latency" {
  alarm_name          = "${var.env}-${var.service}-DB-High-WriteLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "This alarm monitors for high DB write latency"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora.cluster_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth" {
  alarm_name          = "${var.env}-${var.service}-DB-High-DiskQueueDepth"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.aurora_settings["disk_queue_depth_alarm_threshold"]
  alarm_description   = "This alarm monitors for high DB disk queue depth"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora.cluster_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "buffer_cache_hit_ratio" {
  alarm_name          = "${var.env}-${var.service}-DB-Low-BufferCacheHitRatio"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BufferCacheHitRatio"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.aurora_settings["buffer_cache_hit_ratio_alarm_threshold"]
  alarm_description   = "This alarm monitors for high DB disk queue depth"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora.cluster_identifier
  }
}
