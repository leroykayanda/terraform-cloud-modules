resource "aws_s3_bucket" "b" {
  bucket = "${var.env}-${var.company_name}-${var.microservice_name}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  bucket = aws_s3_bucket.b.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.b.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_app_bucket" {
  count  = var.create_lifecycle_config == "yes" ? 1 : 0
  bucket = aws_s3_bucket.b.id

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
}

resource "aws_s3_bucket_versioning" "versioning" {
  count  = var.env == "prod" ? 1 : 0
  bucket = aws_s3_bucket.b.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_role" "s3_replication" {
  count = var.env == "prod" ? 1 : 0
  name  = "${var.env}-${var.microservice_name}-s3-replication"

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

resource "aws_iam_policy" "s3_replication" {
  count = var.env == "prod" ? 1 : 0
  name  = "${var.env}-${var.microservice_name}-s3-replication"

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
        "${aws_s3_bucket.b.arn}"
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
        "${aws_s3_bucket.b.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.b_dr[0].arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "s3_replication" {
  count      = var.env == "prod" ? 1 : 0
  role       = aws_iam_role.s3_replication[0].name
  policy_arn = aws_iam_policy.s3_replication[0].arn
}

resource "aws_s3_bucket_replication_configuration" "replication_configuration" {
  count = var.env == "prod" ? 1 : 0
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  role   = aws_iam_role.s3_replication[0].arn
  bucket = aws_s3_bucket.b.id

  rule {
    id = "replicate"

    filter {
    }

    status = "Enabled"

    destination {
      bucket = aws_s3_bucket.b_dr[0].arn

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
}
