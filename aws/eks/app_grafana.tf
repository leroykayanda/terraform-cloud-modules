# # grafana namespace

# resource "kubernetes_namespace" "grafana" {
#   count = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
#   metadata {
#     name = "grafana"
#   }
# }

# # prometheus helm chart

# resource "helm_release" "prometheus" {
#   count      = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
#   name       = "prometheus"
#   chart      = "prometheus"
#   version    = "25.21.0"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   namespace  = "grafana"

#   set {
#     name  = "server.persistentVolume.size"
#     value = var.prometheus["pv_storage"]
#   }

#   set {
#     name  = "server.retention"
#     value = var.prometheus["retention"]
#   }

#   set {
#     name  = "server.service.type"
#     value = "NodePort"
#   }

#   values = [
#     <<EOF
#     server:
#       tolerations:
#       - key: "priority"
#         operator: "Equal"
#         value: "critical"
#         effect: "NoSchedule"
#       nodeSelector:
#         priority: "critical"
#     EOF
#   ]

#   depends_on = [
#     kubernetes_namespace.grafana
#   ]

# }

# # prometheus dns name

# resource "aws_route53_record" "prometheus" {
#   count   = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
#   zone_id = var.zone_id
#   name    = var.prometheus["dns_name"]
#   type    = "A"

#   alias {
#     name                   = data.aws_lb.ingress[0].dns_name
#     zone_id                = data.aws_lb.ingress[0].zone_id
#     evaluate_target_health = false
#   }
# }

# # prometheus ingress

# resource "kubernetes_ingress_v1" "prometheus" {
#   count = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
#   metadata {
#     name      = "prometheus"
#     namespace = "grafana"
#     annotations = {
#       "alb.ingress.kubernetes.io/backend-protocol"         = "HTTP"
#       "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
#       "alb.ingress.kubernetes.io/ssl-redirect"             = "443"
#       "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
#       "alb.ingress.kubernetes.io/load-balancer-name"       = "${var.env}-eks-cluster"
#       "alb.ingress.kubernetes.io/subnets"                  = "${var.public_ingress_subnets}"
#       "alb.ingress.kubernetes.io/certificate-arn"          = "${var.certificate_arn}"
#       "alb.ingress.kubernetes.io/load-balancer-attributes" = var.argocd["load_balancer_attributes"]
#       "alb.ingress.kubernetes.io/target-group-attributes"  = var.argocd["target_group_attributes"]
#       "alb.ingress.kubernetes.io/tags"                     = var.argocd["tags"]
#       "alb.ingress.kubernetes.io/success-codes"            = "200-399"
#       "alb.ingress.kubernetes.io/group.name"               = var.env
#     }
#   }

#   spec {
#     ingress_class_name = "alb"

#     rule {
#       host = var.prometheus["dns_name"]

#       http {
#         path {
#           path = "/*"

#           backend {
#             service {
#               name = "prometheus-server"
#               port {
#                 number = 80
#               }
#             }
#           }

#         }
#       }
#     }

#     tls {
#       hosts = [var.prometheus["dns_name"]]
#     }
#   }
# }

# # grafana helm chart

# resource "helm_release" "grafana" {
#   count      = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
#   name       = "grafana"
#   chart      = "grafana"
#   version    = "7.3.11"
#   repository = "https://grafana.github.io/helm-charts"
#   namespace  = "grafana"

#   set {
#     name  = "persistence.enabled"
#     value = "true"
#   }

#   set {
#     name  = "persistence.size"
#     value = var.grafana["pv_storage"]
#   }

#   set {
#     name  = "service.type"
#     value = "NodePort"
#   }

#   set {
#     name  = "persistence.storageClassName"
#     value = var.grafana["storageClassName"]
#   }

#   set {
#     name  = "adminPassword"
#     value = var.grafana_password
#   }

#   values = [
#     <<EOF
# tolerations:
# - key: "priority"
#   operator: "Equal"
#   value: "critical"
#   effect: "NoSchedule"
# nodeSelector:
#   priority: "critical"
# datasources:
#   datasources.yaml:
#     apiVersion: 1
#     datasources:
#       - name: Prometheus
#         type: prometheus
#         url: http://prometheus-server.grafana
#         access: proxy
#         isDefault: true
# dashboardProviders:
#     dashboardproviders.yaml:
#         apiVersion: 1
#         providers:
#         - name: 'default'
#           orgId: 1
#           folder: ''
#           type: file
#           disableDeletion: false
#           editable: true
#           options:
#             path: /var/lib/grafana/dashboards/default
# dashboards:
#   default:
#     kubernetes-dashboard:
#       json: |
#         ${indent(8, file("${path.module}/dashboard.json"))}
# grafana.ini:
#   server:
#     domain: "${var.grafana["dns_name"]}"
#     root_url: "%(protocol)s://%(domain)s/"
# alerting: 
#   contactpoints.yaml:
#     secret:
#       apiVersion: 1
#       contactPoints:
#         - orgId: 1
#           name: slack_alerts
#           receivers:
#             - uid: slack
#               type: slack
#               settings:
#                 url: "${var.slack_incoming_webhook_url}"
#   rules.yaml:
#     apiVersion: 1
#     groups:
#       - orgId: 1
#         name: evaluation_group
#         folder: "${var.env}-env"
#         interval: 5m
#   policies.yaml:
#     policies:
#       - orgId: 1
#         receiver: slack_alerts
# EOF
#   ]

# }

# # grafana dns name

# resource "aws_route53_record" "grafana" {
#   count   = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
#   zone_id = var.zone_id
#   name    = var.grafana["dns_name"]
#   type    = "A"

#   alias {
#     name                   = data.aws_lb.ingress[0].dns_name
#     zone_id                = data.aws_lb.ingress[0].zone_id
#     evaluate_target_health = false
#   }
# }

# # grafana ingress

# resource "kubernetes_ingress_v1" "grafana" {
#   count = var.cluster_created && var.metrics_type == "prometheus-grafana" ? 1 : 0
#   metadata {
#     name      = "grafana"
#     namespace = "grafana"
#     annotations = {
#       "alb.ingress.kubernetes.io/backend-protocol"         = "HTTP"
#       "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
#       "alb.ingress.kubernetes.io/ssl-redirect"             = "443"
#       "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
#       "alb.ingress.kubernetes.io/load-balancer-name"       = "${var.env}-eks-cluster"
#       "alb.ingress.kubernetes.io/subnets"                  = "${var.public_ingress_subnets}"
#       "alb.ingress.kubernetes.io/certificate-arn"          = "${var.certificate_arn}"
#       "alb.ingress.kubernetes.io/load-balancer-attributes" = var.argocd["load_balancer_attributes"]
#       "alb.ingress.kubernetes.io/target-group-attributes"  = var.argocd["target_group_attributes"]
#       "alb.ingress.kubernetes.io/tags"                     = var.argocd["tags"]
#       "alb.ingress.kubernetes.io/success-codes"            = "200-399"
#       "alb.ingress.kubernetes.io/group.name"               = var.env
#     }
#   }

#   spec {
#     ingress_class_name = "alb"

#     rule {
#       host = var.grafana["dns_name"]

#       http {
#         path {
#           path = "/*"

#           backend {
#             service {
#               name = "grafana"
#               port {
#                 number = 80
#               }
#             }
#           }

#         }
#       }
#     }

#     tls {
#       hosts = [var.grafana["dns_name"]]
#     }
#   }
# }
