variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "team" {
  type        = string
  description = "Used to tag resources"
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
}

variable "region" {
  type = string
}

variable "company_name" {
  type        = string
  description = "To make bucket name unique"
}

#eks
variable "cluster_created" {
  description = "create applications such as argocd only when the eks cluster has already been created"
  default     = false
}

variable "metrics_type" {
  description = "cloudwatch or prometheus-grafana"
  default     = "cloudwatch"
}

variable "logs_type" {
  description = "cloudwatch or elk"
  default     = "cloudwatch"
}

variable "autoscaling_type" {
  description = "cluster-autoscaler or karpenter"
  default     = "karpenter"
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "cluster_endpoint_public_access" {
  default = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "nodegroup_properties" {
  type = any
  default = {
    "min_size"       = 1
    "max_size"       = 2
    "desired_size"   = 1
    "instance_types" = ["t4g.2xlarge"]
    "capacity_type"  = "ON_DEMAND"
  }
}

variable "critical_nodegroup" {
  type = any
  default = {
    "min_size"       = 2
    "max_size"       = 2
    "desired_size"   = 1
    "instance_types" = ["t4g.2xlarge"]
    "capacity_type"  = "ON_DEMAND"
  }
}

variable "autoscaler_service_name" {
  type    = string
  default = "cluster-autoscaler-sa"
}

variable "container_insights_service_name" {
  type    = string
  default = "container-insights"
}

variable "lb_service_name" {
  type    = string
  default = "lb-controller"
}

variable "access_entries" {
  type        = map(any)
  default     = {}
  description = "Map of access entries for the EKS cluster"
}

#argocd
variable "public_ingress_subnets" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "argo_ssh_private_key" {
  description = "The SSH private key"
  type        = string
}

variable "argo_slack_token" {
  type = string
}

variable "argocd" {
  type = any
}

variable "karpenter" {
  type = any
}

variable "argocd_image_updater_values" {
}

# elastic

variable "elastic" {
  type = any
}

variable "elastic_password" {
  type = string
}

variable "kibana" {
  type = any
}

variable "prometheus" {
  type = any
}

variable "grafana" {
  type = any
}

variable "slack_incoming_webhook_url" {
  type = string
}

variable "grafana_password" {
  type = string
}
