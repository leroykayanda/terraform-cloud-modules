
output "aurora_writer_endpoint" {
  value = aws_rds_cluster.aurora.endpoint
}

output "aurora_id" {
  value = aws_rds_cluster.aurora.id
}

output "aurora_id_dr" {
  value = aws_rds_cluster.aurora_dr.id
}

