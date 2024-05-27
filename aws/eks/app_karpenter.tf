# resource "helm_release" "insights" {
#   count      = var.cluster_created && var.autoscaling_type == "cluster-autoscaler" ? 1 : 0
#   name       = var.container_insights_service_name
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-cloudwatch-metrics"
#   namespace  = "kube-system"

#   set {
#     name  = "clusterName"
#     value = var.cluster_name
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = var.container_insights_service_name
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = false
#   }

#   depends_on = [
#     kubernetes_service_account.container_insights_sa
#   ]
# }
