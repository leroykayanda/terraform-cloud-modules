data "aws_db_cluster_snapshot" "snapshot" {
  count                          = var.restoring_snaphot ? 1 : 0
  db_cluster_identifier          = var.snapshot_cluster
  db_cluster_snapshot_identifier = var.db_cluster_snapshot_identifier
}
