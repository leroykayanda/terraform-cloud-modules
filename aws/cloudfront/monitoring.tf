resource "aws_cloudwatch_dashboard" "dash" {
  dashboard_name = "${var.env}-${var.service}-Cloudfront"
  dashboard_body = jsonencode(
    {
      "widgets" : [
        {
          "type" : "metric",
          "x" : 0,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/CloudFront", "Requests", "Region", "Global", "DistributionId", aws_cloudfront_distribution.cf.id]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Sum",
            "period" : 60
          }
        },
        {
          "type" : "metric",
          "x" : 6,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              [{ "expression" : "m1/1000000", "label" : "MegaBytesDownloaded", "id" : "e1" }],
              ["AWS/CloudFront", "BytesDownloaded", "Region", "Global", "DistributionId", aws_cloudfront_distribution.cf.id, { "visible" : false, "id" : "m1", "period" : 60 }]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 300,
            "title" : "MegaBytesDownloaded"
          }
        },
        {
          "type" : "metric",
          "x" : 12,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/CloudFront", "5xxErrorRate", "Region", "Global", "DistributionId", aws_cloudfront_distribution.cf.id]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60
          }
        },
        {
          "type" : "metric",
          "x" : 18,
          "y" : 0,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/CloudFront", "CacheHitRate", "Region", "Global", "DistributionId", aws_cloudfront_distribution.cf.id]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60
          }
        },
        {
          "type" : "metric",
          "x" : 0,
          "y" : 6,
          "width" : 6,
          "height" : 6,
          "properties" : {
            "metrics" : [
              ["AWS/CloudFront", "OriginLatency", "Region", "Global", "DistributionId", aws_cloudfront_distribution.cf.id]
            ],
            "view" : "timeSeries",
            "stacked" : true,
            "region" : var.region,
            "stat" : "Average",
            "period" : 60
          }
        }
      ]
    }
  )
}
