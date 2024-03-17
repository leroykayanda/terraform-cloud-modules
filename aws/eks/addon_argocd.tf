# resource "kubernetes_namespace" "ns" {
#   count = var.cluster_created ? 1 : 0
#   metadata {
#     name = "argocd"
#   }
# }

# resource "helm_release" "argocd" {
#   count      = var.cluster_created ? 1 : 0
#   name       = "argo-cd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   namespace  = "argocd"
#   version    = "5.52.1"

#   set {
#     name  = "server.service.type"
#     value = "NodePort"
#   }

#   set {
#     name  = "notifications.secret.create"
#     value = false
#   }

#   set {
#     name  = "notifications.cm.create"
#     value = false
#   }

#   set {
#     name  = "notifications.containerPorts.metrics"
#     value = 9002
#   }

#   values = [
#     <<EOT
# configs:
#   cm:
#     "timeout.reconciliation": "60s"
# EOT
#   ]
# }
