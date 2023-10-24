
output "id" {
  value = aws_efs_file_system.efs_file_system.id
}

output "access_point_id" {
  value = aws_efs_access_point.efs_access_point.id
}
