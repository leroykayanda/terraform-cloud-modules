output "bucket" {
  value = aws_s3_bucket.b.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.b.arn
}

output "bucket_dr" {
  value = var.env == "prod" ? aws_s3_bucket.b_dr[0].bucket : null
}
