resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = "${var.env}-${var.service}"
  kafka_version          = var.kafka_settings["version"]
  number_of_broker_nodes = var.kafka_settings["number_of_broker_nodes"]
  enhanced_monitoring    = var.kafka_settings["enhanced_monitoring_level"]
  tags                   = var.tags

  broker_node_group_info {
    instance_type  = var.kafka_settings["instance_type"]
    client_subnets = var.client_subnets
    storage_info {
      ebs_storage_info {
        volume_size = var.kafka_settings["broker_ebs_volume_size"]
      }
    }

    connectivity_info {
      public_access {
        type = var.kafka_settings["public_access"]
      }
    }
    security_groups = [var.kafka_security_group_id]
  }

  client_authentication {
    sasl {
      scram = true
      iam   = true
    }

    tls {}
  }

  encryption_info {

  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.cloudwatch_log_group.name
      }
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.config.arn
    revision = aws_msk_configuration.config.latest_revision
  }

  lifecycle {
    ignore_changes = [client_authentication]
  }

}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "${var.env}-${var.service}-kafka-logs"
  retention_in_days = var.kafka_logs_retention_period
  tags              = var.tags
}

resource "aws_msk_scram_secret_association" "association" {
  cluster_arn     = aws_msk_cluster.msk_cluster.arn
  secret_arn_list = [aws_secretsmanager_secret.secret.arn]
  depends_on      = [aws_secretsmanager_secret_version.version]
}

resource "aws_secretsmanager_secret" "secret" {
  name                    = "AmazonMSK_${var.env}_${var.service}"
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.kms.key_id
  tags                    = var.tags
}

resource "aws_kms_key" "kms" {
  description             = "Key for MSK Cluster Scram Secret Association"
  deletion_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "version" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(
    {
      username = var.scram_credentials["username"],
      password = var.scram_credentials["password"]
  })
}

resource "aws_secretsmanager_secret_policy" "policy" {
  secret_arn = aws_secretsmanager_secret.secret.arn
  policy     = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Sid": "AWSKafkaResourcePolicy",
    "Effect" : "Allow",
    "Principal" : {
      "Service" : "kafka.amazonaws.com"
    },
    "Action" : "secretsmanager:getSecretValue",
    "Resource" : "${aws_secretsmanager_secret.secret.arn}"
  } ]
}
POLICY
}

resource "aws_msk_configuration" "config" {
  name              = "${var.env}-${var.service}-msk-config"
  kafka_versions    = [var.kafka_settings["version"]]
  server_properties = <<-EOF
    allow.everyone.if.no.acl.found=false
    auto.create.topics.enable=true
    default.replication.factor=${var.kafka_settings["default_replication_factor"]}
    num.partitions=${var.kafka_settings["default_partitions_per_topic"]}
    log.retention.hours=${var.kafka_settings["default_log_retention_hours"]}
  EOF
}

data "aws_msk_configuration" "config" {
  name = aws_msk_configuration.config.name
}
