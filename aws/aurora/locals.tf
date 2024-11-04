locals {
  snapshot_identifier = var.restoring_snaphot ? data.aws_db_cluster_snapshot.snapshot[0].id : null
}
