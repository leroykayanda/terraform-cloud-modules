resource "aws_elasticache_subnet_group" "subnet_group" {
  count      = var.subnet_group_name == null ? 1 : 0
  name       = "${local.world}${local.separator}${var.service}"
  subnet_ids = var.subnets
}

resource "aws_elasticache_replication_group" "group" {
  replication_group_id       = "${local.world}${local.separator}${var.service}"
  description                = var.description
  node_type                  = var.node_type
  num_cache_clusters         = var.num_cache_clusters
  multi_az_enabled           = var.multi_az_enabled
  automatic_failover_enabled = var.automatic_failover_enabled
  parameter_group_name       = var.parameter_group_name
  port                       = var.port
  engine                     = var.engine
  engine_version             = var.engine_version
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  maintenance_window         = var.maintenance_window
  snapshot_window            = var.snapshot_window
  notification_topic_arn     = var.sns_topic["low_urgency"]
  subnet_group_name          = local.subnet_group_name
  security_group_ids         = var.security_groups
  snapshot_retention_limit   = var.snapshot_retention_limit
  tags                       = var.tags
}


