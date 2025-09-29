locals {
  separator         = var.world == "none" ? "" : "-"
  world             = var.world == "none" ? "" : var.world
  subnet_group_name = var.subnet_group_name != null ? var.subnet_group_name : aws_elasticache_subnet_group.subnet_group[0].name
}

