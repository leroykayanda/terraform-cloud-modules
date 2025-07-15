resource "aws_db_subnet_group" "subnet_group" {
  count       = var.replicate_source_db == null ? 1 : 0
  name        = "${local.world}${local.separator}${var.service}"
  subnet_ids  = var.db_subnets
  description = "Subnets for the db"
  tags        = var.tags
}

resource "aws_kms_key" "kms_key" {
  count                   = var.replicate_source_db == null ? 1 : 0
  description             = "Encrypts the ${local.world}${local.separator}${var.service} db"
  deletion_window_in_days = var.kms_key_deletion
  tags                    = var.tags
}

resource "aws_db_instance" "db_instance" {
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  apply_immediately                     = true
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  backup_retention_period               = var.backup_retention_period
  db_name                               = var.db_name
  db_subnet_group_name                  = local.db_subnet_group_name
  delete_automated_backups              = var.delete_automated_backups
  deletion_protection                   = var.deletion_protection
  engine                                = var.engine
  engine_version                        = var.engine_version
  final_snapshot_identifier             = "${local.world}${local.separator}${var.service}"
  identifier                            = "${local.world}${local.separator}${var.service}"
  instance_class                        = var.instance_class
  kms_key_id                            = local.kms_key_id
  multi_az                              = var.multi_az
  storage_encrypted                     = var.storage_encrypted
  username                              = var.db_username
  password                              = var.db_password
  skip_final_snapshot                   = var.skip_final_snapshot
  port                                  = var.port
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  vpc_security_group_ids                = var.vpc_security_group_ids
  maintenance_window                    = var.maintenance_window
  backup_window                         = var.backup_window
  storage_type                          = var.storage_type
  iops                                  = var.iops
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  parameter_group_name                  = var.parameter_group_name
  publicly_accessible                   = var.publicly_accessible
  tags                                  = var.tags
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  replicate_source_db                   = var.replicate_source_db
  timeouts {
    create = "120m" # 2 hours
    update = "120m" # 2 hours
    delete = "60m"  # 1 hour
  }
}
