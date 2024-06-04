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
