resource "aws_opensearch_domain" "os" {
  domain_name    = "${var.env}-${var.service}"
  engine_version = var.engine_version
  tags           = var.tags

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
    zone_awareness_enabled = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
  }

  advanced_security_options {
    enabled                        = var.advanced_security_options["enabled"]
    internal_user_database_enabled = var.advanced_security_options["internal_user_database_enabled"]
    master_user_options {
      master_user_name     = var.master_user["name"]
      master_user_password = var.master_user["password"]
    }
  }

  encrypt_at_rest {
    enabled = var.encrypt_at_rest
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  domain_endpoint_options {
    enforce_https                   = var.domain_endpoint_options["enforce_https"]
    custom_endpoint_enabled         = var.domain_endpoint_options["custom_endpoint_enabled"]
    custom_endpoint                 = var.domain_endpoint_options["custom_endpoint"]
    custom_endpoint_certificate_arn = var.domain_endpoint_options["custom_endpoint_certificate_arn"]
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }

  ebs_options {
    ebs_enabled = var.ebs_options["ebs_enabled"]
    volume_size = var.ebs_options["volume_size"]
    iops        = var.ebs_options["iops"]
    throughput  = var.ebs_options["throughput"]
    volume_type = var.ebs_options["volume_type"]
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.logs.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": {
        "AWS": "*"
      },
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.env}-${var.service}/*"
    }
  ]
}
POLICY

  depends_on = [aws_cloudwatch_log_resource_policy.policy]
}


# Logging configuration

resource "aws_cloudwatch_log_group" "logs" {
  name              = "${var.env}-${var.service}-opensearch-domain"
  retention_in_days = var.log_retention_days
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }

    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
      "logs:CreateLogStream",
    ]

    resources = ["${aws_cloudwatch_log_group.logs.arn}:*"]
  }
}
resource "aws_cloudwatch_log_resource_policy" "policy" {
  policy_name     = "os"
  policy_document = data.aws_iam_policy_document.policy.json
}
