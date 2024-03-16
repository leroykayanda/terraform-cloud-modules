resource "kubernetes_namespace" "ns" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name = "argocd"
  }
}
