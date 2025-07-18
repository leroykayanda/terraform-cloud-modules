locals {
  separator            = var.world == "none" ? "" : "-"
  world                = var.world == "none" ? "" : var.world
  db_subnet_group_name = var.replicate_source_db == null ? aws_db_subnet_group.subnet_group[0].name : null
  kms_key_id           = var.replicate_source_db == null && !var.use_default_kms_key ? aws_kms_key.kms_key[0].arn : null
}

