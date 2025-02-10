resource "aws_directory_service_directory" "ds" {
  name     = var.name
  password = var.password
  size     = var.size
  tags     = var.tags
  type     = var.type

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_ids
  }
}
