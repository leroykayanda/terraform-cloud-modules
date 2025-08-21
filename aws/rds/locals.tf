locals {
  separator            = var.world == "none" ? "" : "-"
  world                = var.world == "none" ? "" : var.world
  db_subnet_group_name = var.replicate_source_db == null ? aws_db_subnet_group.subnet_group[0].name : null
  identifier           = var.identifier != null ? var.identifier : "${local.world}${local.separator}${var.service}"
}

