resource "aws_dynamodb_table" "ddb" {
  name                        = "${var.env}-${var.service}"
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  billing_mode                = var.billing_mode
  deletion_protection_enabled = var.deletion_protection_enabled
  tags                        = var.tags
  table_class                 = var.table_class

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
    }
  }

  point_in_time_recovery {
    enabled                 = var.point_in_time_recovery_enabled
    recovery_period_in_days = var.recovery_period_in_days
  }

  server_side_encryption {
    enabled = var.server_side_encryption_enabled
  }
}
