resource "helm_release" "karpenter" {
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

  values = [
    <<EOF
    controller:
      resources: 
        requests:
          cpu: "100m"
          memory: "256Mi"
        limits:
          cpu: "1000m"
          memory: "1Gi"
    EOF
  ]
}
