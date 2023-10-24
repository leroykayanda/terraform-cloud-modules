resource "doppler_environment" "env" {
  project = var.project
  slug    = var.env
  name    = var.env
}

resource "aws_iam_role" "doppler_parameter_store" {
  name = "doppler_parameter_store_${var.project}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          AWS = "arn:aws:iam::299900769157:user/doppler-integration-operator"
        },
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.workplace_slug
          }
        }
      },
    ]
  })

  inline_policy {
    name = "doppler_secret_manager"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [

            "ssm:PutParameter",
            "ssm:LabelParameterVersion",
            "ssm:DeleteParameter",
            "ssm:RemoveTagsFromResource",
            "ssm:GetParameterHistory",
            "ssm:AddTagsToResource",
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter",
            "ssm:DeleteParameters"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "doppler_integration_aws_parameter_store" "integration" {
  name            = var.env
  assume_role_arn = aws_iam_role.doppler_parameter_store.arn
}

resource "doppler_secrets_sync_aws_parameter_store" "sync" {
  integration = doppler_integration_aws_parameter_store.integration.id
  project     = var.project
  config      = var.env

  region        = var.region
  path          = var.path
  secure_string = true
  tags          = { created_by = "doppler" }
}
