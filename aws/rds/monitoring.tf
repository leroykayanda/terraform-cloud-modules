resource "aws_cloudwatch_metric_alarm" "freeable_memory_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-Memory-Usage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["freeable_memory"]
  alarm_description   = "This alarm monitors for when the DB is running out of memory"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_high_urgency" {
  alarm_name          = "High-Urgency-${local.world}${local.separator}${var.service}-DB-High-Memory-Usage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_urgency_alarm_thresholds["freeable_memory"]
  alarm_description   = "This alarm monitors for when the DB is running out of memory"
  alarm_actions       = [var.sns_topic["high_urgency"]]
  ok_actions          = [var.sns_topic["high_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-Low-Storage-Space"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["free_storage_space"]
  alarm_description   = "This alarm monitors for when the DB is running out of storage"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_high_urgency" {
  alarm_name          = "High-Urgency-${local.world}${local.separator}${var.service}-DB-Low-Storage-Space"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_urgency_alarm_thresholds["free_storage_space"]
  alarm_description   = "This alarm monitors for when the DB is running out of storage"
  alarm_actions       = [var.sns_topic["high_urgency"]]
  ok_actions          = [var.sns_topic["high_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-CPU-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["cpu"]
  alarm_description   = "This alarm monitors for high DB CPU usage"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high_urgency" {
  alarm_name          = "High-Urgency-${local.world}${local.separator}${var.service}-DB-High-CPU-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_urgency_alarm_thresholds["cpu"]
  alarm_description   = "This alarm monitors for high DB CPU usage"
  alarm_actions       = [var.sns_topic["high_urgency"]]
  ok_actions          = [var.sns_topic["high_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-DiskQueueDepth"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 30
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["disk_queue_depth"]
  alarm_description   = "This alarm monitors for high DB DiskQueueDepth"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "30"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "read_latency_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-ReadLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["read_latency"]
  alarm_description   = "This alarm monitors for high DB ReadLatency"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "5"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "write_latency_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-WriteLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["write_latency"]
  alarm_description   = "This alarm monitors for high DB WriteLatency"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "5"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "iops_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-IOPs-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "15"
  threshold           = var.low_urgency_alarm_thresholds["iops"]
  alarm_description   = "This alarm monitors for high DB IOPs usage"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  metric_query {
    id          = "e1"
    expression  = "m1+m2"
    label       = "Total IOPs"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "ReadIOPS"
      namespace   = "AWS/RDS"
      period      = 300
      stat        = "Average"

      dimensions = {
        DBInstanceIdentifier = aws_db_instance.db_instance.identifier
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "WriteIOPS"
      namespace   = "AWS/RDS"
      period      = 300
      stat        = "Average"

      dimensions = {
        DBInstanceIdentifier = aws_db_instance.db_instance.identifier
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "iops_high_urgency" {
  alarm_name          = "High-Urgency-${local.world}${local.separator}${var.service}-DB-High-IOPs-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "15"
  threshold           = var.high_urgency_alarm_thresholds["iops"]
  alarm_description   = "This alarm monitors for high DB IOPs usage"
  alarm_actions       = [var.sns_topic["high_urgency"]]
  ok_actions          = [var.sns_topic["high_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  metric_query {
    id          = "e1"
    expression  = "m1+m2"
    label       = "Total IOPs"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "ReadIOPS"
      namespace   = "AWS/RDS"
      period      = 300
      stat        = "Average"

      dimensions = {
        DBInstanceIdentifier = aws_db_instance.db_instance.identifier
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "WriteIOPS"
      namespace   = "AWS/RDS"
      period      = 300
      stat        = "Average"

      dimensions = {
        DBInstanceIdentifier = aws_db_instance.db_instance.identifier
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_lag_low_urgency" {
  count               = var.replicate_source_db != null ? 1 : 0
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-ReplicaLag"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["replica_lag"]
  alarm_description   = "This alarm monitors for high DB ReplicaLag"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "replica_lag_high_urgency" {
  count               = var.replicate_source_db != null ? 1 : 0
  alarm_name          = "High-Urgency-${local.world}${local.separator}${var.service}-DB-High-ReplicaLag"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_urgency_alarm_thresholds["replica_lag"]
  alarm_description   = "This alarm monitors for high DB ReplicaLag"
  alarm_actions       = [var.sns_topic["high_urgency"]]
  ok_actions          = [var.sns_topic["high_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "oldest_replication_slot_lag_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-Replication-Slot-Lag"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "OldestReplicationSlotLag"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["oldest_replication_slot_lag"]
  alarm_description   = "This alarm monitors for high DB OldestReplicationSlotLag"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "oldest_replication_slot_lag_high_urgency" {
  alarm_name          = "High-Urgency-${local.world}${local.separator}${var.service}-DB-High-Replication-Slot-Lag"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "OldestReplicationSlotLag"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_urgency_alarm_thresholds["oldest_replication_slot_lag"]
  alarm_description   = "This alarm monitors for high DB OldestReplicationSlotLag"
  alarm_actions       = [var.sns_topic["high_urgency"]]
  ok_actions          = [var.sns_topic["high_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "db_load_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-DB-High-DBLoad"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "DBLoad"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["db_load"]
  alarm_description   = "This alarm monitors for high DBLoad"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.identifier
  }
}

resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${local.world}${local.separator}${var.service}-DB"

  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "free_memory",
                  "value" : 50000000000
                }
              ]
            },
            "metrics" : [
              ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier, { "region" : var.region }]
            ],
            "period" : 300,
            "region" : var.region,
            "stacked" : true,
            "stat" : "Average",
            "view" : "timeSeries"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 6,
          "type" : "metric",
          "properties" : {
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "usage",
                  "value" : 90
                }
              ]
            },
            "metrics" : [
              ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier]
            ],
            "period" : 300,
            "region" : var.region,
            "stacked" : true,
            "stat" : "Average",
            "view" : "timeSeries"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 12,
          "type" : "metric",
          "properties" : {
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "queue_depth",
                  "value" : 30
                }
              ]
            },
            "metrics" : [
              ["AWS/RDS", "DiskQueueDepth", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier, { "period" : 300 }]
            ],
            "region" : var.region,
            "stacked" : true,
            "stat" : "Average",
            "view" : "timeSeries"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 18,
          "type" : "metric",
          "properties" : {
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "free_storage",
                  "value" : 3000000000000
                }
              ]
            },
            "metrics" : [
              ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier, { "period" : 300 }]
            ],
            "region" : var.region,
            "stacked" : true,
            "stat" : "Average",
            "view" : "timeSeries"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 6,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "latency",
                  "value" : 0.5
                }
              ]
            },
            "metrics" : [
              ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier],
              [".", "WriteLatency", ".", "."]
            ],
            "period" : 300,
            "region" : var.region,
            "stacked" : false,
            "stat" : "Average",
            "view" : "timeSeries"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 6,
          "x" : 6,
          "type" : "metric",
          "properties" : {
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "iops",
                  "value" : 30000
                }
              ]
            },
            "metrics" : [
              [{ "expression" : "m1+m2", "id" : "e1", "label" : "Total IOPs" }],
              ["AWS/RDS", "WriteIOPS", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier, { "id" : "m1", "visible" : false }],
              [".", "ReadIOPS", ".", ".", { "id" : "m2", "visible" : false }]
            ],
            "period" : 60,
            "region" : var.region,
            "stacked" : true,
            "stat" : "Average",
            "view" : "timeSeries",
            "title" : "IOPS Usage"
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
              ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier]
            ],
            "period" : 300,
            "region" : var.region,
            "stacked" : true,
            "stat" : "Average",
            "view" : "timeSeries"
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
              ["AWS/RDS", "OldestReplicationSlotLag", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier, { "period" : 60 }]
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
              ["AWS/RDS", "DBLoad", "DBInstanceIdentifier", aws_db_instance.db_instance.identifier, { "period" : 60, "region" : var.region }]
            ],
            "region" : var.region,
            "period" : 300,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "load",
                  "value" : var.low_urgency_alarm_thresholds["db_load"]
                }
              ]
            }
          }
        }
      ]
    }
  )
}
