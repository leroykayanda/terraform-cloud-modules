#The metric in the widget follows https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html#CloudWatch-Dashboard-Properties-Metrics-Array-Format
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
  env_short_names_map = {
    Development = "dev"
    Staging     = "stage"
    Sandbox     = "sand"
    Production  = "prod"
  }
  env_short_name = lookup(local.env_short_names_map, var.environment, "dev")
  dashboard_name = "${var.dashboard_name}-${var.service_name}-${local.env_short_name}"
  widgets = [
    for metric_map_obj in var.metrics : {
      height = 7
      width  = 8
      type   = "metric"
      properties = {
        view    = lookup(metric_map_obj, "view", "timeSeries")
        stat    = lookup(metric_map_obj, "stat", "Average")
        region  = lookup(metric_map_obj, "region", var.region)
        stacked = "true" == lookup(metric_map_obj, "stacked", "false")
        metrics = jsondecode(lookup(metric_map_obj, "metrics"))
        region  = var.region
        title   = lookup(metric_map_obj, "title")

      }
    }
  ]
}

resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = local.dashboard_name

  dashboard_body = jsonencode(
    {
      start          = "-P7D"
      periodOverride = "auto"
      widgets        = local.widgets
    }
  )
}
