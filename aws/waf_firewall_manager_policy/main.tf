resource "aws_s3_bucket" "b" {
  bucket = "${var.company_name}-firewall-manager-waf-logs"

  tags = {
    Team = var.team
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_alb_access_logs" {
  bucket = aws_s3_bucket.b.id

  rule {
    expiration {
      days = 90
    }
    status = "Enabled"
    id     = "expire-logs"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_access_log_bucket" {
  bucket = aws_s3_bucket.b.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_fms_policy" "fms_policy" {
  name                               = "set_up_WAF_on_all_ALBs_2"
  exclude_resource_tags              = false
  remediation_enabled                = true
  resource_type                      = "AWS::ElasticLoadBalancingV2::LoadBalancer"
  delete_unused_fm_managed_resources = true

  resource_tags = {
    waf = "yes"
  }

  include_map {
    account = var.include_map
  }

  security_service_policy_data {
    type = "WAFV2"

    managed_service_data = jsonencode({
      type                              = "WAFV2"
      overrideCustomerWebACLAssociation = false
      postProcessRuleGroups             = []

      preProcessRuleGroups = [
        {
          excludeRules = []
          managedRuleGroupIdentifier = {
            vendorName           = "AWS"
            managedRuleGroupName = "AWSManagedRulesAmazonIpReputationList"
            version              = null
          }
          overrideAction = {
            type = "NONE"
          }
          ruleGroupArn           = null
          ruleGroupType          = "ManagedRuleGroup"
          sampledRequestsEnabled = true
        },
        {
          excludeRules = [
            {
              name = "NoUserAgent_HEADER"
            },
            {
              name = "SizeRestrictions_BODY"
            },
            {
              name = "EC2MetaDataSSRF_BODY"
            },
            {
              name = "GenericRFI_BODY"
            },
            {
              name = "CrossSiteScripting_BODY"
            }
          ]
          managedRuleGroupIdentifier = {
            managedRuleGroupName = "AWSManagedRulesCommonRuleSet"
            vendorName           = "AWS"
            version              = null
          }
          overrideAction = {
            type = "NONE"
          }
          ruleGroupArn           = null
          ruleGroupType          = "ManagedRuleGroup"
          sampledRequestsEnabled = true
        },
      ]
      sampledRequestsEnabledForDefaultActions = true
      defaultAction = {
        type = "ALLOW"
      }
      loggingConfiguration = {
        logDestinationConfigs = [
          aws_kinesis_firehose_delivery_stream.kinesis_firehose_delivery_stream.arn
        ]
      }
    })
  }

  lifecycle {
    ignore_changes = [
      security_service_policy_data
    ]
  }

  tags = {
    Name = "set_up_WAF_on_all_ALBs"
    Team = var.team
  }
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose_delivery_stream" {
  name        = "aws-waf-logs-firehose-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.b.arn
    buffering_size     = 5
    buffering_interval = 300

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.CloudWatchLogGroup.name
      log_stream_name = "fire"
    }
  }

  tags = {
    Team = var.team
  }
}

resource "aws_cloudwatch_log_group" "CloudWatchLogGroup" {
  name              = "firehose-logs"
  retention_in_days = 30

  tags = {
    Team = var.team
  }
}

resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  name           = "fire"
  log_group_name = aws_cloudwatch_log_group.CloudWatchLogGroup.name
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "firehose_inline_policy" {
  name = "firehose_inline_policy"
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "FirehoseWrite"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.b.arn}/*"
      },
      {
        Sid    = "FirehoseListBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "${aws_s3_bucket.b.arn}"
      },
      {
        Effect = "Allow"
        Action = [
          "firehose:CreateDeliveryStream",
          "firehose:PutRecordBatch",
          "firehose:ListDeliveryStreams"
        ]
        Resource = "*"
      }
    ]
  })
}
