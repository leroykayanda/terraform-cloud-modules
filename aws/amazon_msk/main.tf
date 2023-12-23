resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = "${var.env}-${var.microservice_name}"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.kafka_enhanced_monitoring

  broker_node_group_info {
    instance_type  = var.broker_instance_type
    client_subnets = var.kafka_client_subnets
    storage_info {
      ebs_storage_info {
        volume_size = var.broker_ebs_volume_size
      }
    }

    connectivity_info {
      public_access {
        type = var.public_access
      }
    }
    security_groups = [var.security_group_id]
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
        log_group = aws_cloudwatch_log_group.CloudWatchLogGroup.name
      }
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.config.arn
    revision = 1
  }

  lifecycle {
    ignore_changes = [client_authentication]
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_cloudwatch_log_group" "CloudWatchLogGroup" {
  name              = "${var.env}-${var.microservice_name}-kafka-logs"
  retention_in_days = var.kafka_logs_retention_period

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_msk_scram_secret_association" "association" {
  cluster_arn     = aws_msk_cluster.msk_cluster.arn
  secret_arn_list = [aws_secretsmanager_secret.secret.arn]

  depends_on = [aws_secretsmanager_secret_version.version]
}

resource "aws_secretsmanager_secret" "secret" {
  name       = "AmazonMSK_${var.env}_${var.microservice_name}_4"
  kms_key_id = aws_kms_key.kms.key_id
}

resource "aws_kms_key" "kms" {
  description             = "Key for MSK Cluster Scram Secret Association"
  deletion_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode({ username = "${var.scram_user}", password = "${var.scram_password}" })
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
  name              = "msk-config-${var.env}-${var.microservice_name}"
  kafka_versions    = ["2.8.1"]
  server_properties = <<EOF
    allow.everyone.if.no.acl.found=false
    auto.create.topics.enable=true
    default.replication.factor=2
    num.partitions=2
  EOF
}
