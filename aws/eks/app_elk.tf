# elk namespace

resource "kubernetes_namespace" "elk" {
  count = var.cluster_created && var.logs_type == "elk" ? 1 : 0
  metadata {
    name = "elk"
  }
}

# elasticsearch

resource "helm_release" "elastic" {
  count      = var.cluster_created && var.logs_type == "elk" ? 1 : 0
  name       = "elasticsearch"
  chart      = "elasticsearch"
  version    = "8.5.1"
  repository = "https://helm.elastic.co"
  namespace  = "elk"

  set {
    name  = "replicas"
    value = var.elastic["replicas"]
  }

  set {
    name  = "minimumMasterNodes"
    value = var.elastic["minimumMasterNodes"]
  }

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = var.elastic["pv_storage"]
  }

  set {
    name  = "createCert"
    value = "true"
  }

  set {
    name  = "protocol"
    value = "https"
  }

  set {
    name  = "secret.password"
    value = var.elastic_password
  }

  values = [
    <<EOF
    esConfig: 
      elasticsearch.yml: |
        xpack.security.enabled: true
    resources: 
      requests:
        cpu: "500m"
        memory: "1Gi"
      limits:
        cpu: "1000m"
        memory: "2Gi"
    EOF
  ]

  depends_on = [
    kubernetes_namespace.elk
  ]

}

# kibana helm chart

resource "helm_release" "kibana" {
  count      = var.cluster_created && var.logs_type == "elk" ? 1 : 0
  name       = "kibana"
  chart      = "kibana"
  version    = "8.5.1"
  repository = "https://helm.elastic.co"
  namespace  = "elk"

  set {
    name  = "elasticsearchHosts"
    value = "https://elasticsearch-master.elk:9200"
  }

  set {
    name  = "automountToken"
    value = false
  }

  values = [
    <<EOF
    resources: 
      requests:
        cpu: "500m"
        memory: "1Gi"
      limits:
        cpu: "1000m"
        memory: "2Gi"
    EOF
  ]

  depends_on = [
    helm_release.elastic
  ]

}
