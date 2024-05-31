# grafana namespace

resource "kubernetes_namespace" "grafana" {
  count = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
  metadata {
    name = "grafana"
  }
}

# prometheus helm chart

resource "helm_release" "prometheus" {
  count      = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
  name       = "prometheus"
  chart      = "prometheus"
  version    = "25.21.0"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = "grafana"

  set {
    name  = "server.persistentVolume.size"
    value = var.prometheus["pv_storage"]
  }

  set {
    name  = "server.retention"
    value = var.prometheus["retention"]
  }

  depends_on = [
    kubernetes_namespace.grafana
  ]

}
