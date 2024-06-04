# EBS

resource "kubernetes_storage_class" "sc" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true

  parameters = {
    type   = "gp3"
    fsType = "ext4"
  }
}

# EFS

resource "aws_efs_file_system" "efs" {
  creation_token   = "${var.cluster_name}-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"

  tags = {
    Name        = "${var.cluster_name}-efs"
    Environment = var.env
    Team        = var.team
  }
}

# security group

resource "aws_security_group" "efs" {
  name        = "${var.cluster_name}-efs-sg"
  description = "Allow inbound efs traffic from VPC CIDR"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = [var.vpc_cidr]
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
  }

  tags = {
    Name        = "${var.cluster_name}-efs-sg"
    Environment = var.env
    Team        = var.team
  }
}

# Mount target

resource "aws_efs_mount_target" "efs_mount_target" {
  count           = length(var.private_subnets)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.private_subnets[count.index]
  security_groups = [aws_security_group.efs.id]
}
