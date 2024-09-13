resource "aws_mq_configuration" "config" {
  name           = "${var.env}-${var.service}"
  engine_type    = var.mq_settings["engine_type"]
  engine_version = var.mq_settings["engine_version"]
  tags           = var.tags

  data = <<DATA
secure.management.http.headers.enabled = true
consumer_timeout = 1800000
DATA
}

resource "aws_mq_broker" "mq" {
  broker_name                = "${var.env}-${var.service}"
  engine_type                = var.mq_settings["engine_type"]
  engine_version             = var.mq_settings["engine_version"]
  host_instance_type         = var.mq_settings["host_instance_type"]
  apply_immediately          = true
  deployment_mode            = var.mq_settings["deployment_mode"]
  publicly_accessible        = var.mq_settings["publicly_accessible"]
  storage_type               = var.mq_settings["storage_type"]
  subnet_ids                 = var.subnet_ids
  auto_minor_version_upgrade = true
  tags                       = var.tags

  configuration {
    id       = aws_mq_configuration.config.id
    revision = aws_mq_configuration.config.latest_revision
  }

  user {
    username = var.mq_credentials["username"]
    password = var.mq_credentials["password"]
  }

  encryption_options {
    use_aws_owned_key = false
  }

  maintenance_window_start_time {
    day_of_week = "SUNDAY"
    time_of_day = "23:00"
    time_zone   = "GMT"
  }

  lifecycle {
    ignore_changes = [engine_version]
  }
}
