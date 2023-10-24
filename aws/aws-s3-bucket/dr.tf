resource "aws_s3_bucket" "b_dr" {
  count    = var.env == "prod" ? 1 : 0
  bucket   = "${var.dr_env}-${var.company_name}-${var.microservice_name}"
  provider = aws.dr

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Environment = var.dr_env
    Team        = var.team
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_dr" {
  count  = var.env == "prod" ? 1 : 0
  bucket = aws_s3_bucket.b_dr[0].bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  provider = aws.dr
}

resource "aws_s3_bucket_public_access_block" "public_dr" {
  count  = var.env == "prod" ? 1 : 0
  bucket = aws_s3_bucket.b_dr[0].bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  provider = aws.dr
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_app_bucket_dr" {
  count  = var.env == "prod" && var.create_lifecycle_config == "yes" ? 1 : 0
  bucket = aws_s3_bucket.b_dr[0].bucket

  rule {
    expiration {
      days = var.retention
    }

    noncurrent_version_expiration {
      noncurrent_days = 10
    }

    status = "Enabled"
    id     = "app-files"
  }

  provider = aws.dr
}

resource "aws_s3_bucket_versioning" "versioning_dr" {
  count  = var.env == "prod" ? 1 : 0
  bucket = aws_s3_bucket.b_dr[0].bucket
  versioning_configuration {
    status = "Enabled"
  }

  provider = aws.dr
}

resource "aws_iam_role" "s3_replication_dr" {
  count    = var.env == "prod" ? 1 : 0
  name     = "${var.dr_env}-${var.microservice_name}-s3-replication"
  provider = aws.dr

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "s3_replication_dr" {
  count    = var.env == "prod" ? 1 : 0
  name     = "${var.dr_env}-${var.microservice_name}-s3-replication"
  provider = aws.dr

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.b_dr[0].arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
         "s3:GetObjectVersionTagging"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.b_dr[0].arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.b.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "s3_replication_dr" {
  count      = var.env == "prod" ? 1 : 0
  role       = aws_iam_role.s3_replication_dr[0].name
  policy_arn = aws_iam_policy.s3_replication_dr[0].arn
  provider   = aws.dr
}

resource "aws_s3_bucket_replication_configuration" "replication_configuration_dr" {
  count = var.env == "prod" ? 1 : 0
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning_dr]

  role   = aws_iam_role.s3_replication_dr[0].arn
  bucket = aws_s3_bucket.b_dr[0].id

  rule {

    id = "replicate"

    filter {
    }

    status = "Enabled"

    destination {
      bucket = aws_s3_bucket.b.arn

      metrics {
        event_threshold {
          minutes = 15
        }
        status = "Enabled"
      }

      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }

    }

    delete_marker_replication {
      status = "Enabled"
    }

  }

  provider = aws.dr
}
