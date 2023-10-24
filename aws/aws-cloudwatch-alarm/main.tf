terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.26.0"
    }
  }
  required_version = ">= 1.2.0"
}

data "aws_caller_identity" "current" {}

locals {
  region     = "eu-west-1"
  account_id = data.aws_caller_identity.current.account_id
  alarm_name = "${var.env}-${var.service_name}-${var.alarm_name}"
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  count               = var.env == "prod" || var.env == "dr" ? 1 : 0
  alarm_name          = local.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = "1"
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  period              = "300"
  statistic           = var.statistic
  threshold           = var.threshold
  alarm_description   = var.alarm_description
  alarm_actions       = ["arn:aws:sns:${var.region}:${local.account_id}:${var.sns_topic_name}"]
  datapoints_to_alarm = "1"
  treat_missing_data  = var.treat_missing_data

  dimensions = var.dimensions
  tags = {
    ServiceName = var.service_name
    Name        = local.alarm_name
    Owner       = var.team_name
    Environment = var.env
    Status      = "active"
  }

}
