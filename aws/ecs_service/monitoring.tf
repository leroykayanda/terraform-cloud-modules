resource "aws_cloudwatch_dashboard" "dash" {
  count          = var.task_launch_type == "EC2" ? 1 : 0
  dashboard_name = "${var.world}-${var.service}-ECS-Service"

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
              ["AWS/ECS", "MemoryUtilization", "ServiceName", "${var.world}-${var.service}", "ClusterName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "title" : "Service Memory Utilization",
            "period" : 60,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "usage",
                  "value" : 90
                }
              ]
            },
            "stat" : "Average"
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
              ["AWS/ECS", "MemoryUtilization", "ClusterName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "period" : 60,
            "stat" : "Average",
            "title" : "Cluster Memory Utilization",
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
          "height" : 6,
          "width" : 6,
          "y" : 6,
          "x" : 6,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/ECS", "CPUUtilization", "ServiceName", "${var.world}-${var.service}", "ClusterName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "title" : "Service CPU Utilization",
            "period" : 60,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "usage",
                  "value" : 90
                }
              ]
            },
            "stat" : "Average"
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
              ["AWS/ECS", "CPUUtilization", "ClusterName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "period" : 60,
            "stat" : "Average",
            "title" : "Cluster CPU Utilization",
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
          "height" : 6,
          "width" : 6,
          "y" : 0,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["ECS/ContainerInsights", "DesiredTaskCount", "ServiceName", "${var.world}-${var.service}", "ClusterName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60,
            "title" : "Desired TaskCount"
          }
        },
        {
          "height" : 6,
          "width" : 7,
          "y" : 0,
          "x" : 12,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["ECS/ContainerInsights", "PendingTaskCount", "ServiceName", "${var.world}-${var.service}", "ClusterName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Maximum",
            "period" : 60,
            "title" : "Pending TaskCount"
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
              ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", "${var.world}-${var.service}", "ClusterName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Minimum",
            "period" : 60,
            "title" : "Running TaskCount"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 18,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["ECS/ContainerInsights", "ContainerInstanceCount", "ClusterName", "${var.world}-${var.cluster_name}"]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "period" : 60,
            "stat" : "Maximum"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 18,
          "x" : 6,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/AutoScaling", "GroupPendingInstances", "AutoScalingGroupName", "${var.world}-${var.cluster_name}"]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Maximum",
            "period" : 60,
            "title" : "ASG Pending Instances"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 12,
          "x" : 12,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/EC2", "NetworkIn", "AutoScalingGroupName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "title" : "ASG NetworkIn",
            "period" : 60,
            "stat" : "Average"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 12,
          "x" : 18,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/EC2", "NetworkOut", "AutoScalingGroupName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "title" : "ASG NetworkOut",
            "period" : 60,
            "stat" : "Average"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 18,
          "x" : 12,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/AutoScaling", "GroupTerminatingInstances", "AutoScalingGroupName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "title" : "ASG Terminating Instances",
            "period" : 60,
            "stat" : "Maximum"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 18,
          "x" : 18,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/ECS/ManagedScaling", "CapacityProviderReservation", "ClusterName", "${var.world}-${var.cluster_name}", "CapacityProviderName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "title" : "CapacityProviderReservation",
            "period" : 60,
            "stat" : "Average"
          }
        },
        {
          "height" : 6,
          "width" : 6,
          "y" : 12,
          "x" : 0,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["CWAgent", "mem_used_percent", "AutoScalingGroupName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "title" : "ASG Memory Used as per CWAgent",
            "period" : 60,
            "stat" : "Average",
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
          "height" : 6,
          "width" : 6,
          "y" : 12,
          "x" : 6,
          "type" : "metric",
          "properties" : {
            "metrics" : [
              ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${var.world}-${var.cluster_name}", { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : false,
            "region" : var.region,
            "title" : "ASG CPU Utilization",
            "period" : 60,
            "stat" : "Average",
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
          "y" : 24,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [{ "expression" : "m1/m2*100", "label" : "ASG Usage", "id" : "e1", "region" : var.region }],
              ["AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", "${var.cluster_name}-ecs-capacity-prov-cluster-node", { "id" : "m1", "visible" : false, "region" : var.region }],
              [".", "GroupMaxSize", ".", ".", { "id" : "m2", "visible" : false, "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 300,
            "annotations" : {
              "horizontal" : [
                {
                  "label" : "ASG Usage",
                  "value" : 90
                }
              ]
            },
            "title" : "ASG Maximum Capacity Usage"
          }
        }
      ]
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "service_memory" {
  count               = var.active_alarms["service_memory"] ? 1 : 0
  alarm_name          = "${var.world}-${var.service}-ECS-Service-High-Memory-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = var.alarm_periods["service_memory"]
  statistic           = "Average"
  threshold           = var.alarm_thresholds["service_memory"]
  alarm_description   = "This alarm monitors for high ECS service memory"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    ServiceName = "${var.world}-${var.service}"
    ClusterName = "${var.world}-${var.cluster_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "service_cpu" {
  count               = var.active_alarms["service_cpu"] ? 1 : 0
  alarm_name          = "${var.world}-${var.service}-ECS-Service-High-CPU-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.alarm_periods["service_cpu"]
  statistic           = "Average"
  threshold           = var.alarm_thresholds["service_cpu"]
  alarm_description   = "This alarm monitors for high ECS service CPU"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    ServiceName = "${var.world}-${var.service}"
    ClusterName = "${var.world}-${var.cluster_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "running_tasks" {
  count               = var.active_alarms["running_tasks"] ? 1 : 0
  alarm_name          = "${var.world}-${var.service}-ECS-Service-No-Running-Tasks"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = var.alarm_periods["running_tasks"]
  statistic           = "Minimum"
  threshold           = "0"
  alarm_description   = "This alarm monitors for when there are no running tasks in an ECS service"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    ServiceName = "${var.world}-${var.service}"
    ClusterName = "${var.world}-${var.cluster_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "pending_tasks" {
  count               = var.active_alarms["pending_tasks"] ? 1 : 0
  alarm_name          = "${var.world}-${var.service}-ECS-Service-Pending-Tasks"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "PendingTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = var.alarm_periods["pending_tasks"]
  statistic           = "Average"
  threshold           = "5"
  alarm_description   = "This alarm monitors for when there are pending tasks in an ECS service"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "3"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    ServiceName = "${var.world}-${var.service}"
    ClusterName = "${var.world}-${var.cluster_name}"
  }
}
