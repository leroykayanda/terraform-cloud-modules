resource "aws_dynamodb_table" "ddb" {
  name                        = "${var.env}-${var.microservice_name}"
  hash_key                    = var.ddb_hash_key
  range_key                   = var.ddb_range_key
  billing_mode                = var.ddb_billing_mode
  deletion_protection_enabled = true
  stream_enabled              = true
  stream_view_type            = "NEW_AND_OLD_IMAGES"

  dynamic "attribute" {
    for_each = var.ddb_attributes
    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
    }
  }

  replica {
    region_name = var.ddb_replica_region_name
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = var.env
    Team        = var.team
  }
}
