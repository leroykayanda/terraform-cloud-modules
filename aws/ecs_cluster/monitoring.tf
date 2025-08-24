resource "aws_cloudwatch_metric_alarm" "asg_memory" {
  count               = var.capacity_provider == "EC2" && var.active_alarms["asg_memory"] ? 1 : 0
  alarm_name          = "${var.env}-${var.service}-ASG-High-Memory-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = var.alarm_periods["asg_memory"]
  statistic           = "Average"
  threshold           = var.alarm_thresholds["asg_memory"]
  alarm_description   = "This alarm monitors for when ASG Memory usage is high"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_asg[0].name
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu" {
  count               = var.capacity_provider == "EC2" && var.active_alarms["asg_cpu"] ? 1 : 0
  alarm_name          = "${var.env}-${var.service}-ASG-High-CPU-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.alarm_periods["asg_cpu"]
  statistic           = "Average"
  threshold           = var.alarm_thresholds["asg_cpu"]
  alarm_description   = "This alarm monitors for when ASG CPU usage is high"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_asg[0].name
  }
}

resource "aws_cloudwatch_metric_alarm" "container_instance_count" {
  count               = var.capacity_provider == "EC2" && var.active_alarms["container_instance_count"] ? 1 : 0
  alarm_name          = "${var.env}-${var.service}-ASG-No-Running-Instances"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ContainerInstanceCount"
  namespace           = "ECS/ContainerInsights"
  period              = var.alarm_periods["container_instance_count"]
  statistic           = "Average"
  threshold           = var.alarm_thresholds["container_instance_count"]
  alarm_description   = "This alarm monitors for when there are no running instances in the ASG"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    ClusterName = "${var.env}-${var.service}"
  }
}

resource "aws_cloudwatch_metric_alarm" "asg_max_capacity_usage" {
  count               = var.capacity_provider == "EC2" && var.active_alarms["asg_max_capacity_usage"] ? 1 : 0
  alarm_name          = "${var.env}-${var.service}-ASG-Instances-Close-To-Maximum-ASG-Capacity"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = var.alarm_thresholds["asg_max_capacity_usage"]
  alarm_description   = "This alarm monitors for when instances running are nearing ASG maximum capacity"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "1"
  treat_missing_data  = "ignore"
  tags                = var.tags

  metric_query {
    id          = "e1"
    expression  = "m1/m2*100"
    label       = "ASG Usage"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "GroupInServiceInstances"
      namespace   = "AWS/AutoScaling"
      period      = var.alarm_periods["asg_max_capacity_usage"]
      stat        = "Average"

      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.ecs_asg[0].name
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "GroupMaxSize"
      namespace   = "AWS/AutoScaling"
      period      = var.alarm_periods["asg_max_capacity_usage"]
      stat        = "Average"

      dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.ecs_asg[0].name
      }
    }
  }
}
