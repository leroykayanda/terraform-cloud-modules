output "cloudwatch_loggroup" {
  value = aws_cloudwatch_log_group.CloudWatchLogGroup.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "alb_zone_id" {
  value = module.alb.lb_zone_id
}

output "app-logroup-arn" {
  value = aws_cloudwatch_log_group.CloudWatchLogGroup.arn
}

