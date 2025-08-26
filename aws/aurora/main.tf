resource "aws_db_subnet_group" "subnet_group" {
  name        = "${var.env}-${var.service}"
  subnet_ids  = var.db_subnets
  description = "Subnets for the db"
  tags        = var.tags
}

resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_rds_cluster_parameter_group" "db_parameter_group" {
  name   = "${var.env}-${var.service}-cluster"
  family = var.aurora_settings["parameter_group_family"]
  tags   = var.tags

  parameter {
    name  = "pgaudit.log"
    value = "DDL,ROLE"
  }

  parameter {
    name  = "pgaudit.role"
    value = "rds_pgaudit"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pgaudit"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.env}-${var.service}-instance"
  family = var.aurora_settings["parameter_group_family"]
  tags   = var.tags

  parameter {
    name  = "pgaudit.log"
    value = "DDL,ROLE"
  }

  parameter {
    name  = "pgaudit.role"
    value = "rds_pgaudit"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pgaudit"
    apply_method = "pending-reboot"
  }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier              = "${var.env}-${var.service}"
  apply_immediately               = true
  engine                          = var.aurora_settings["engine"]
  engine_version                  = var.aurora_settings["engine_version"]
  engine_mode                     = var.aurora_settings["engine_mode"]
  availability_zones              = var.availability_zones
  master_username                 = var.db_credentials["user"]
  master_password                 = var.db_credentials["password"]
  backup_retention_period         = var.aurora_settings["backup_retention_period"]
  db_subnet_group_name            = aws_db_subnet_group.subnet_group.name
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  storage_encrypted               = true
  port                            = var.aurora_settings["port"]
  preferred_maintenance_window    = var.preferred_maintenance_window
  preferred_backup_window         = var.preferred_backup_window
  skip_final_snapshot             = false
  vpc_security_group_ids          = [var.security_group_id]
  final_snapshot_identifier       = "${var.env}-${var.service}"
  database_name                   = var.db_credentials["db_name"]
  snapshot_identifier             = local.snapshot_identifier
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_parameter_group.name
  storage_type                    = var.storage_type
  tags                            = var.tags

  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.aurora_settings["serverless_cluster"] ? [1] : []
    content {
      min_capacity = var.aurora_settings["serverless_min_capacity"]
      max_capacity = var.aurora_settings["serverless_max_capacity"]
    }
  }

  lifecycle {
    ignore_changes = [
      availability_zones, snapshot_identifier
    ]
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                                 = var.aurora_settings["db_instance_count"]
  instance_class                        = var.aurora_settings["instance_class"]
  identifier                            = "${var.service}-${count.index}-${random_string.random.id}"
  cluster_identifier                    = aws_rds_cluster.aurora.id
  engine                                = aws_rds_cluster.aurora.engine
  engine_version                        = aws_rds_cluster.aurora.engine_version
  publicly_accessible                   = var.aurora_settings["publicly_accessible"]
  db_subnet_group_name                  = aws_rds_cluster.aurora.db_subnet_group_name
  apply_immediately                     = true
  promotion_tier                        = 2
  preferred_maintenance_window          = aws_rds_cluster.aurora.preferred_maintenance_window
  auto_minor_version_upgrade            = false
  performance_insights_enabled          = true
  performance_insights_retention_period = var.aurora_settings["performance_insights_retention_period"]
  db_parameter_group_name               = aws_db_parameter_group.db_parameter_group.name
  copy_tags_to_snapshot                 = true
  tags                                  = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

