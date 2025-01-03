# RDS proxy

resource "aws_db_proxy" "proxy" {
  name                   = "${local.world}${local.separator}${var.service}"
  debug_logging          = var.debug_logging
  engine_family          = var.engine_family
  idle_client_timeout    = var.idle_client_timeout
  require_tls            = var.require_tls
  role_arn               = var.role_arn
  vpc_security_group_ids = var.vpc_security_group_ids
  vpc_subnet_ids         = var.vpc_subnet_ids
  tags                   = var.tags

  auth {
    auth_scheme               = "SECRETS"
    iam_auth                  = var.iam_auth
    secret_arn                = var.secret_arn
    client_password_auth_type = var.client_password_auth_type
  }
}

# Default target group

resource "aws_db_proxy_default_target_group" "tg" {
  db_proxy_name = aws_db_proxy.proxy.name

  connection_pool_config {
    connection_borrow_timeout = var.connection_pool_config["connection_borrow_timeout"]
    max_connections_percent   = var.connection_pool_config["max_connections_percent"]
  }
}

# Associated DB

resource "aws_db_proxy_target" "db" {
  db_instance_identifier = var.db_instance_identifier
  db_cluster_identifier  = var.db_cluster_identifier
  db_proxy_name          = aws_db_proxy.proxy.name
  target_group_name      = aws_db_proxy_default_target_group.tg.name
}
