resource "aws_db_subnet_group" "subnet_group_dr" {
  provider = aws.dr
  name     = "${var.dr_env}-${var.microservice_name}"

  subnet_ids  = var.dr_private_subnets
  description = "Private subnets for the db"
}

resource "aws_kms_key" "kms_key_dr" {
  provider = aws.dr

  description = "Encrypts the db for ${var.dr_env}-${var.microservice_name}"

  deletion_window_in_days = 7
}

resource "random_string" "random_dr" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_rds_cluster" "aurora_dr" {
  provider                        = aws.dr
  cluster_identifier              = "${var.dr_env}-${var.microservice_name}"
  apply_immediately               = true
  engine                          = "aurora-postgresql"
  engine_version                  = var.engine_version
  engine_mode                     = "provisioned"
  availability_zones              = var.dr_availability_zones
  backup_retention_period         = var.backup_retention_period
  db_subnet_group_name            = aws_db_subnet_group.subnet_group_dr.name
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["postgresql"]
  storage_encrypted               = true
  kms_key_id                      = aws_kms_key.kms_key_dr.arn
  port                            = var.port
  preferred_maintenance_window    = var.preferred_maintenance_window
  preferred_backup_window         = var.preferred_backup_window
  skip_final_snapshot             = false
  vpc_security_group_ids          = [var.dr_security_group_id]
  final_snapshot_identifier       = "${var.dr_env}-${var.microservice_name}"
  global_cluster_identifier       = aws_rds_global_cluster.rds_global_cluster.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_parameter_group_dr.name

  lifecycle {
    ignore_changes = [global_cluster_identifier, replication_source_identifier, availability_zones]
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_rds_cluster_instance" "cluster_instances_dr" {

  provider                              = aws.dr
  instance_class                        = var.db_cluster_instance_class
  count                                 = var.db_instance_count
  identifier                            = "${var.microservice_name}-${count.index}-${random_string.random_dr.id}"
  cluster_identifier                    = aws_rds_cluster.aurora_dr.id
  engine                                = aws_rds_cluster.aurora_dr.engine
  engine_version                        = aws_rds_cluster.aurora_dr.engine_version
  publicly_accessible                   = false
  db_subnet_group_name                  = aws_rds_cluster.aurora_dr.db_subnet_group_name
  apply_immediately                     = true
  promotion_tier                        = 2
  preferred_maintenance_window          = aws_rds_cluster.aurora_dr.preferred_maintenance_window
  auto_minor_version_upgrade            = true
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = aws_kms_key.kms_key_dr.arn
  performance_insights_retention_period = 7
  db_parameter_group_name               = aws_db_parameter_group.db_parameter_group_dr.name

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [instance_class]
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_CPUUtilization_dr" {
  provider            = aws.dr
  alarm_name          = "${var.dr_env}-${var.microservice_name}-DB-High-CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "900"
  statistic           = "Maximum"
  threshold           = "90"
  alarm_description   = "This alarm monitors for high database CPU"
  alarm_actions       = [var.dr_sns_topic]
  ok_actions          = [var.dr_sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora_dr.cluster_identifier
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_FreeableMemory_dr" {
  provider            = aws.dr
  alarm_name          = "${var.dr_env}-${var.microservice_name}-DB-Low-Memory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Minimum"
  threshold           = "500000000"
  alarm_description   = "This alarm monitors for low database memory"
  alarm_actions       = [var.dr_sns_topic]
  ok_actions          = [var.dr_sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora_dr.cluster_identifier
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_ReadLatency_dr" {
  provider            = aws.dr
  alarm_name          = "${var.dr_env}-${var.microservice_name}-DB-High-ReadLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "This alarm monitors for high read latency"
  alarm_actions       = [var.dr_sns_topic]
  ok_actions          = [var.dr_sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora_dr.cluster_identifier
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_WriteLatency_dr" {
  provider            = aws.dr
  alarm_name          = "${var.dr_env}-${var.microservice_name}-DB-High-WriteLatency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "This alarm monitors for high write latency"
  alarm_actions       = [var.dr_sns_topic]
  ok_actions          = [var.dr_sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora_dr.cluster_identifier
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_DiskQueueDepth_dr" {
  provider            = aws.dr
  alarm_name          = "${var.dr_env}-${var.microservice_name}-DB-High-DiskQueueDepth"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "100"
  alarm_description   = "This alarm monitors for high disk queue depth"
  alarm_actions       = [var.dr_sns_topic]
  ok_actions          = [var.dr_sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.aurora_dr.cluster_identifier
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_DBLoad_dr" {
  provider            = aws.dr
  alarm_name          = "${var.dr_env}-${var.microservice_name}-DB-High-DBLoad"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DBLoad"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "This alarm monitors for high DB Load. Check RDS performace insights for details."
  alarm_actions       = [var.dr_sns_topic]
  ok_actions          = [var.dr_sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"

  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.cluster_instances_dr[0].id
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_cloudwatch_dashboard" "dash_dr" {
  provider       = aws.dr
  dashboard_name = "${var.dr_env}-${var.microservice_name}-DB"

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
            "metrics" : [
              ["AWS/RDS", "CPUUtilization", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier, { "region" : "${var.dr_region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.dr_region}",
            "stat" : "Maximum",
            "period" : 300,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "cpu",
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
              [{ "expression" : "m1/1000000000", "label" : "FreeableMemory", "id" : "e1", "region" : "${var.dr_region}" }],
              ["AWS/RDS", "FreeableMemory", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier, { "id" : "m1", "visible" : false, "region" : "${var.dr_region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.dr_region}",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "mem Gb",
                  "value" : 1
                }
              ]
            },
            "stat" : "Minimum",
            "period" : 300,
            "title" : "FreeableMemory",
            "yAxis" : {
              "left" : {
                "showUnits" : false
              }
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
              ["AWS/RDS", "ReadLatency", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier],
              [".", "WriteLatency", ".", "."]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.dr_region}",
            "stat" : "Maximum",
            "period" : 300
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 18,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/RDS", "VolumeBytesUsed", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier, { "region" : "${var.dr_region}", "label" : "VolumeBytesUsed" }],
              [".", "BackupRetentionPeriodStorageUsed", ".", "prod-finflow", { "region" : "${var.dr_region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.dr_region}",
            "stat" : "Maximum",
            "period" : 300,
            "yAxis" : {
              "left" : {
                "showUnits" : false
              }
            }
          }
        },
        {
          "type" : "metric",
          "x" : 12,
          "y" : 12,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [{ "expression" : "(m1+m2)/300", "label" : "IOPs", "id" : "e1", "region" : "${var.dr_region}" }],
              ["AWS/RDS", "VolumeReadIOPs", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier, { "id" : "m1", "visible" : false, "region" : "${var.dr_region}" }],
              [".", "VolumeWriteIOPs", ".", ".", { "id" : "m2", "visible" : false, "region" : "${var.dr_region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.dr_region}",
            "stat" : "Maximum",
            "period" : 300,
            "title" : "IOPs",
            "yAxis" : {
              "left" : {
                "showUnits" : false
              }
            }
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
              ["AWS/RDS", "BufferCacheHitRatio", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier]
            ],
            "region" : "${var.dr_region}",
            "stat" : "Minimum",
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
              ["AWS/RDS", "CommitThroughput", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier]
            ],
            "region" : "${var.dr_region}",
            "stat" : "Maximum",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "commits/sec",
                  "value" : 500
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
            "metrics" : [
              ["AWS/RDS", "DatabaseConnections", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier, { "region" : "${var.dr_region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.dr_region}",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "connections",
                  "value" : 100
                }
              ]
            },
            "period" : 300,
            "stat" : "Sum"
          }
        },
        {
          "type" : "metric",
          "x" : 6,
          "y" : 12,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/RDS", "DBLoad", "DBInstanceIdentifier", aws_rds_cluster_instance.cluster_instances_dr[0].id, { "region" : "${var.dr_region}" }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.dr_region}",
            "stat" : "Average",
            "period" : 60,
            "title" : "DBLoad",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "load",
                  "value" : 10
                }
              ]
            },
            "yAxis" : {
              "left" : {
                "showUnits" : false
              }
            }
          }
        },
        {
          "type" : "metric",
          "x" : 6,
          "y" : 6,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "Deadlocks", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier]
            ],
            "region" : "${var.dr_region}",
            "stat" : "Maximum",
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
              ["AWS/RDS", "DiskQueueDepth", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier]
            ],
            "region" : "${var.dr_region}",
            "stat" : "Maximum",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "queue_depth",
                  "value" : 100
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
              [{ "expression" : "m1/1000000000", "label" : "FreeLocalStorage", "id" : "e1", "region" : "${var.dr_region}" }],
              ["AWS/RDS", "FreeLocalStorage", "DBInstanceIdentifier", aws_rds_cluster_instance.cluster_instances_dr[0].id, { "region" : "${var.dr_region}", "id" : "m1", "visible" : false }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : "${var.dr_region}",
            "period" : 300,
            "stat" : "Minimum",
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "free_local_storage Gb",
                  "value" : 10
                }
              ]
            },
            "title" : "FreeLocalStorage",
            "yAxis" : {
              "left" : {
                "showUnits" : false
              }
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
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/RDS", "SwapUsage", "DBClusterIdentifier", aws_rds_cluster.aurora_dr.cluster_identifier]
            ],
            "region" : "${var.dr_region}",
            "stat" : "Maximum",
          }
        }
      ]
    }
  )
}

