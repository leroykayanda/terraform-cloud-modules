
resource "aws_security_group" "efs_sg" {
  name        = "${var.env}-${var.service}-EFS"
  description = "${var.env}-${var.service}-EFS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-${var.service}-EFS"
  }

  ingress {
    description = "EFS Traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_efs_file_system" "efs_file_system" {
  encrypted        = var.encrypted
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  tags = merge(
    var.tags,
    {
      "Name" = "${var.env}-${var.service}"
    }
  )
}

resource "aws_efs_mount_target" "efs_mount_target" {
  for_each        = toset(var.private_subnets)
  file_system_id  = aws_efs_file_system.efs_file_system.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs_sg.id]
}
