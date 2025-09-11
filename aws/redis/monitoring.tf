resource "aws_cloudwatch_metric_alarm" "freeable_memory_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-Redis-High-Memory-Usage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["freeable_memory"]
  alarm_description   = "This alarm monitors for when Redis is running out of memory"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    CacheClusterId = element(tolist(aws_elasticache_replication_group.group.member_clusters), 0)
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_high_urgency" {
  alarm_name          = "High-Urgency-${local.world}${local.separator}${var.service}-Redis-High-Memory-Usage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_urgency_alarm_thresholds["freeable_memory"]
  alarm_description   = "This alarm monitors for when Redis is running out of memory"
  alarm_actions       = [var.sns_topic["high_urgency"]]
  ok_actions          = [var.sns_topic["high_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    CacheClusterId = element(tolist(aws_elasticache_replication_group.group.member_clusters), 0)
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low_urgency" {
  alarm_name          = "Low-Urgency-${local.world}${local.separator}${var.service}-Redis-High-CPU-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.low_urgency_alarm_thresholds["cpu"]
  alarm_description   = "This alarm monitors for when Redis has high CPU usage"
  alarm_actions       = [var.sns_topic["low_urgency"]]
  ok_actions          = [var.sns_topic["low_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    CacheClusterId = element(tolist(aws_elasticache_replication_group.group.member_clusters), 0)
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high_urgency" {
  alarm_name          = "High-Urgency-${local.world}${local.separator}${var.service}-Redis-High-CPU-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.high_urgency_alarm_thresholds["cpu"]
  alarm_description   = "This alarm monitors for when Redis has high CPU usage"
  alarm_actions       = [var.sns_topic["high_urgency"]]
  ok_actions          = [var.sns_topic["high_urgency"]]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    CacheClusterId = element(tolist(aws_elasticache_replication_group.group.member_clusters), 0)
  }
}


