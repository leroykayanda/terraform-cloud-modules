output "cluster_db_parameter_group" {
  value = aws_rds_cluster_parameter_group.db_parameter_group.id
}

output "instance_db_parameter_group" {
  value = aws_db_parameter_group.db_parameter_group.id
}
