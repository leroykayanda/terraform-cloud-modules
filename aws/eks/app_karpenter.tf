resource "helm_release" "insights" {
  count      = var.cluster_created && var.autoscaling_type == "karpenter" ? 1 : 0
  name       = "karpenter"
  repository = "https://charts.karpenter.sh/"
  chart      = "karpenter"
  namespace  = "kube-system"
  version    = "0.16.3"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = var.container_insights_service_name
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  depends_on = [
    kubernetes_service_account.container_insights_sa
  ]
}
