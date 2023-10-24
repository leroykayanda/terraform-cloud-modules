resource "aws_sns_topic" "sns_topic" {
  name            = "${var.env}-${var.service}"
  policy          = data.aws_iam_policy_document.sns_topic_policy.json
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 1,
      "maxDelayTarget": 8,
      "numMaxDelayRetries": 5,
      "numNoDelayRetries": 3,
      "numMinDelayRetries": 2,
      "numRetries": 10,
      "backoffFunction": "exponential"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 10
    }
  }
}
EOF

  lifecycle {
    ignore_changes = [
      policy
    ]
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "https"
  endpoint  = var.endpoint
  redrive_policy = jsonencode({
    "deadLetterTargetArn" : var.dlq_arn
  })
  endpoint_auto_confirms = true
}
