
resource "confluent_environment" "env" {
  display_name = "${var.service}-${var.env}"
}

resource "confluent_kafka_cluster" "cluster" {
  display_name = "${var.service}-${var.env}-cluster"
  availability = var.availability
  cloud        = "AWS"
  region       = var.region

  dynamic "basic" {
    for_each = contains(["development", "staging"], var.env) ? [1] : []
    content {}
  }

  dynamic "standard" {
    for_each = var.env == "production" ? [1] : []
    content {}
  }

  environment {
    id = confluent_environment.env.id
  }
}

resource "confluent_service_account" "service_account" {
  display_name = "${var.service}-${var.env}-service-account"
  description  = "Service account to manage Kafka cluster"
}

resource "confluent_api_key" "api_key" {
  display_name = "${var.service}-${var.env}"
  owner {
    id          = confluent_service_account.service_account.id
    api_version = confluent_service_account.service_account.api_version
    kind        = confluent_service_account.service_account.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.cluster.id
    api_version = confluent_kafka_cluster.cluster.api_version
    kind        = confluent_kafka_cluster.cluster.kind

    environment {
      id = confluent_environment.env.id
    }
  }
}

resource "confluent_role_binding" "role_binding" {
  principal   = "User:${confluent_service_account.service_account.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.cluster.rbac_crn
}

/* resource "confluent_kafka_acl" "acl" {
  kafka_cluster {
    id = confluent_kafka_cluster.cluster.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.service_account.id}"
  host          = "*"
  operation     = "ALL"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.cluster.rest_endpoint

  credentials {
    key    = var.confluent_cloud_api_key
    secret = var.confluent_cloud_api_secret
  }
} */
