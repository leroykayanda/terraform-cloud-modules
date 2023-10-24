
resource "aws_security_group" "efs_sg" {
  name        = "${var.env}-${var.microservice_name}-control-efs-traffic"
  description = "Control efs traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Service Traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}

resource "aws_efs_file_system" "efs_file_system" {
  creation_token   = "${var.env}-${var.microservice_name}"
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Environment = var.env
    Team        = var.team
    Name        = "${var.env}-${var.microservice_name}"
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  for_each        = toset(var.private_subnets)
  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_access_point" "efs_access_point" {
  file_system_id = aws_efs_file_system.efs_file_system.id

  posix_user {
    gid = 0
    uid = 0
  }

  tags = {
    Environment = var.env
    Team        = var.team
    Name        = "${var.env}-${var.microservice_name}"
  }
}
