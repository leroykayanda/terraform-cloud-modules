resource "aws_cloudwatch_metric_alarm" "freeable_memory" {
  alarm_name          = "${local.env}${local.separator}${var.service}-Redis-High-Memory-Usage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_thresholds["freeable_memory"]
  alarm_description   = "This alarm monitors for when Redis is running out of memory"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    CacheClusterId = element(tolist(aws_elasticache_replication_group.group.member_clusters), 0)
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "${local.env}${local.separator}${var.service}-Redis-High-CPU-Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 15
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = var.alarm_thresholds["cpu"]
  alarm_description   = "This alarm monitors for when Redis has high CPU usage"
  alarm_actions       = [var.sns_topic]
  ok_actions          = [var.sns_topic]
  datapoints_to_alarm = "15"
  treat_missing_data  = "ignore"
  tags                = var.tags

  dimensions = {
    CacheClusterId = element(tolist(aws_elasticache_replication_group.group.member_clusters), 0)
  }
}


