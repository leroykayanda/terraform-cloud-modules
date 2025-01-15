resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.env}-${var.service}"
  elasticsearch_version = var.elasticsearch_version
  tags                  = var.tags

  advanced_security_options {
    enabled                        = var.advanced_security_options["enabled"]
    internal_user_database_enabled = var.advanced_security_options["internal_user_database_enabled"]
    master_user_options {
      master_user_name     = var.master_user["name"]
      master_user_password = var.master_user["password"]
    }
  }

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
    zone_awareness_enabled = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_volume_size
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https                   = true
    custom_endpoint_enabled         = var.domain_endpoint_options["custom_endpoint_enabled"]
    custom_endpoint                 = var.domain_endpoint_options["custom_endpoint"]
    custom_endpoint_certificate_arn = var.domain_endpoint_options["custom_endpoint_certificate_arn"]
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

}
