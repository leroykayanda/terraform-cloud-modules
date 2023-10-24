
data "aws_iam_policy_document" "datadog_aws_integration_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::464622532012:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        var.external_id
      ]
    }
  }
}

data "aws_iam_policy_document" "datadog_aws_integration" {
  statement {
    actions = [
      "apigateway:GET",
      "autoscaling:Describe*",
      "backup:List*",
      "budgets:ViewBudget",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:LookupEvents",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "codedeploy:List*",
      "codedeploy:BatchGet*",
      "directconnect:Describe*",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "ec2:Describe*",
      "ecs:Describe*",
      "ecs:List*",
      "elasticache:Describe*",
      "elasticache:List*",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeTags",
      "elasticfilesystem:DescribeAccessPoints",
      "elasticloadbalancing:Describe*",
      "elasticmapreduce:List*",
      "elasticmapreduce:Describe*",
      "es:ListTags",
      "es:ListDomainNames",
      "es:DescribeElasticsearchDomains",
      "events:CreateEventBus",
      "fsx:DescribeFileSystems",
      "fsx:ListTagsForResource",
      "health:DescribeEvents",
      "health:DescribeEventDetails",
      "health:DescribeAffectedEntities",
      "kinesis:List*",
      "kinesis:Describe*",
      "lambda:GetPolicy",
      "lambda:List*",
      "logs:DeleteSubscriptionFilter",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:DescribeSubscriptionFilters",
      "logs:FilterLogEvents",
      "logs:PutSubscriptionFilter",
      "logs:TestMetricFilter",
      "organizations:Describe*",
      "organizations:List*",
      "rds:Describe*",
      "rds:List*",
      "redshift:DescribeClusters",
      "redshift:DescribeLoggingStatus",
      "route53:List*",
      "s3:GetBucketLogging",
      "s3:GetBucketLocation",
      "s3:GetBucketNotification",
      "s3:GetBucketTagging",
      "s3:ListAllMyBuckets",
      "s3:PutBucketNotification",
      "ses:Get*",
      "sns:List*",
      "sns:Publish",
      "sqs:ListQueues",
      "states:ListStateMachines",
      "states:DescribeStateMachine",
      "support:DescribeTrustedAdvisor*",
      "support:RefreshTrustedAdvisorCheck",
      "tag:GetResources",
      "tag:GetTagKeys",
      "tag:GetTagValues",
      "xray:BatchGetTraces",
      "xray:GetTraceSummaries"
    ]

    resources = ["*"]
  }
}


resource "aws_iam_policy" "datadog_aws_integration" {
  name   = "DatadogAWSIntegrationPolicy"
  policy = data.aws_iam_policy_document.datadog_aws_integration.json
}


resource "aws_iam_role" "datadog_aws_integration" {
  name               = "DatadogAWSIntegrationRole"
  description        = "Role for Datadog AWS Integration"
  assume_role_policy = data.aws_iam_policy_document.datadog_aws_integration_assume_role.json
}

resource "aws_iam_role_policy_attachment" "datadog_aws_integration" {
  role       = aws_iam_role.datadog_aws_integration.name
  policy_arn = aws_iam_policy.datadog_aws_integration.arn
}

resource "datadog_integration_aws" "integration" {
  account_id = data.aws_caller_identity.current.account_id
  role_name  = "DatadogAWSIntegrationRole"

  account_specific_namespace_rules = {
    "api_gateway"                    = false
    "application_elb"                = true
    "apprunner"                      = false
    "appstream"                      = false
    "appsync"                        = false
    "athena"                         = false
    "auto_scaling"                   = false
    "backup"                         = false
    "billing"                        = false
    "budgeting"                      = false
    "certificatemanager"             = false
    "cloudfront"                     = false
    "cloudhsm"                       = false
    "cloudsearch"                    = false
    "cloudwatch_events"              = false
    "cloudwatch_logs"                = false
    "codebuild"                      = false
    "cognito"                        = false
    "connect"                        = false
    "crawl_alarms"                   = false
    "directconnect"                  = false
    "dms"                            = false
    "documentdb"                     = false
    "dynamodb"                       = false
    "dynamodbaccelerator"            = false
    "ebs"                            = false
    "ec2"                            = true
    "ec2api"                         = false
    "ec2spot"                        = false
    "ecr"                            = false
    "ecs"                            = true
    "efs"                            = false
    "elasticache"                    = false
    "elasticbeanstalk"               = false
    "elasticinference"               = false
    "elastictranscoder"              = false
    "elb"                            = false
    "es"                             = false
    "firehose"                       = false
    "fsx"                            = false
    "gamelift"                       = false
    "glue"                           = false
    "inspector"                      = false
    "iot"                            = false
    "keyspaces"                      = false
    "kinesis"                        = false
    "kinesis_analytics"              = false
    "kms"                            = false
    "lambda"                         = false
    "lex"                            = false
    "mediaconnect"                   = false
    "mediaconvert"                   = false
    "medialive"                      = false
    "mediapackage"                   = false
    "mediastore"                     = false
    "mediatailor"                    = false
    "ml"                             = false
    "mq"                             = false
    "msk"                            = false
    "mwaa"                           = false
    "nat_gateway"                    = false
    "neptune"                        = false
    "network_elb"                    = false
    "networkfirewall"                = false
    "opsworks"                       = false
    "polly"                          = false
    "privatelinkendpoints"           = false
    "privatelinkservices"            = false
    "rds"                            = false
    "rdsproxy"                       = false
    "redshift"                       = false
    "rekognition"                    = false
    "route53"                        = false
    "route53resolver"                = false
    "s3"                             = false
    "s3storagelens"                  = false
    "sagemaker"                      = false
    "sagemakerendpoints"             = false
    "sagemakerlabelingjobs"          = false
    "sagemakermodelbuildingpipeline" = false
    "sagemakerprocessingjobs"        = false
    "sagemakertrainingjobs"          = false
    "sagemakertransformjobs"         = false
    "sagemakerworkteam"              = false
    "service_quotas"                 = false
    "ses"                            = false
    "shield"                         = false
    "sns"                            = false
    "step_functions"                 = false
    "storage_gateway"                = false
    "swf"                            = false
    "textract"                       = false
    "transitgateway"                 = false
    "translate"                      = false
    "trusted_advisor"                = false
    "usage"                          = false
    "vpn"                            = false
    "waf"                            = false
    "wafv2"                          = false
    "workspaces"                     = false
    "xray"                           = false
  }

  excluded_regions = [
    "ap-east-1",
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-northeast-3",
    "ap-south-1",
    "ap-south-2",
    "ap-southeast-1",
    "ap-southeast-2",
    "ap-southeast-3",
    "ap-southeast-4",
    "ca-central-1",
    "eu-central-1",
    "eu-central-2",
    "eu-north-1",
    "eu-south-1",
    "eu-south-2",
    "eu-west-1",
    "eu-west-2",
    "me-central-1",
    "me-south-1",
    "sa-east-1",
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",
  ]
  host_tags = [
    "env:${var.env}",
  ]
}
