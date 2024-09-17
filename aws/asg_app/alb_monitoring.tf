resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${var.env}-${var.service}-AutoScalingGroup-App"
  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "type" : "metric",
          "x" : 12,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", aws_lb_target_group.target_group.arn_suffix, "LoadBalancer", module.alb.arn_suffix, { "region" : var.region }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "period" : 60,
            "stat" : "Maximum"
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
              ["AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", module.alb.arn_suffix, { "region" : var.region }]
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
          "x" : 18,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", aws_lb_target_group.target_group.arn_suffix, "LoadBalancer", module.alb.arn_suffix]
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
          "x" : 6,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", module.alb.arn_suffix]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
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
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["CWAgent", "mem_used_percent", "AutoScalingGroupName", aws_autoscaling_group.asg.name, { "region" : var.region }]
            ],
            "region" : var.region,
            "period" : 60,
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
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/AutoScaling", "GroupPendingInstances", "AutoScalingGroupName", aws_autoscaling_group.asg.name]
            ],
            "region" : var.region,
            "stat" : "Maximum",
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
              ["AWS/AutoScaling", "GroupTerminatingInstances", "AutoScalingGroupName", aws_autoscaling_group.asg.name]
            ],
            "region" : var.region,
            "period" : 60,
            "stat" : "Maximum",
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
              ["AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", aws_autoscaling_group.asg.name]
            ],
            "region" : var.region,
            "period" : 60,
            "stat" : "Minimum",
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
              ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.asg.name]
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
          "x" : 6,
          "y" : 12,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "view" : "timeSeries",
            "stacked" : true,
            "metrics" : [
              ["AWS/EC2", "NetworkIn", "AutoScalingGroupName", aws_autoscaling_group.asg.name]
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
              ["AWS/EC2", "NetworkOut", "AutoScalingGroupName", aws_autoscaling_group.asg.name]
            ],
            "region" : var.region
          }
        }
      ]
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
  alarm_name          = "${var.env}-${var.service}-ELB-Unhealthy-Hosts"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "This alarm monitors for ELB unhealthy hosts"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    TargetGroup  = aws_lb_target_group.target_group.arn_suffix
    LoadBalancer = module.alb.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "no_healthy_hosts" {
  alarm_name          = "${var.env}-${var.service}-ELB-No-Healthy-Hosts"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Minimum"
  threshold           = 0
  alarm_description   = "This alarm monitors for when there an no healthy ELB hosts"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    TargetGroup  = aws_lb_target_group.target_group.arn_suffix
    LoadBalancer = module.alb.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_memory" {
  alarm_name          = "${var.env}-${var.service}-ASG-Memory"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This alarm monitors for high ASG memory usage"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu" {
  alarm_name          = "${var.env}-${var.service}-ASG-CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This alarm monitors for high ASG CPU usage"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_running_instances" {
  alarm_name          = "${var.env}-${var.service}-ASG-No-Running-Instances"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = "120"
  statistic           = "Minimum"
  threshold           = 0
  alarm_description   = "This alarm monitors for when there are no running instances in the ASG"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "breaching"
  tags                = var.tags

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}
