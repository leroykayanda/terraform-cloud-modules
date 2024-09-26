variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "region" {
  type = string
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = null
}

variable "company_name" {
  type        = string
  description = "To make bucket name unique"
  default     = "contoso"
}

variable "tags" {
  type        = map(string)
  description = "Used to tag resources"
  default     = {}
}

variable "cluster_tags" {
  type        = map(string)
  description = "Used to tag the EKS cluster"
  default     = {}
}

# EKS
variable "cluster_created" {
  description = "create applications such as argocd only when the eks cluster has already been created"
  default     = false
}

variable "metrics_type" {
  description = "cloudwatch or prometheus-grafana"
  default     = "prometheus-grafana"
}

variable "logs_type" {
  description = "cloudwatch or elk"
  default     = "elk"
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

variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "ON_DEMAND"
}

variable "initial_nodegroup" {
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

variable "create_access_logs_bucket" {
  default     = true
  description = "Whether to create ELB access logs bucket or not"
}

# Argocd
variable "public_ingress_subnets" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "argocd_ssh_private_key" {
  description = "The SSH private key"
  type        = string
}

variable "argocd_slack_token" {
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

# Elastic

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

variable "create_pv_full_alert" {
  default = false
}

variable "slack_incoming_webhook_url" {
  type        = string
  description = "Used by Grafana for sending out alerts."
}

variable "grafana_password" {
  type = string
}

variable "elb_security_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS13-1-2-Ext2-2021-06"
}

variable "elb_access_log_expiration" {
  type        = number
  description = "Days after which to delete ELB access logs"
  default     = 180
}

# Scalyr
variable "set_up_scalyr" {
  type    = bool
  default = false
}

variable "scalyr_api_key" {
  type        = string
  description = "Must be a 'Log Write Access' API key. Log into DataSet and select your account (email address). Then select 'Api Keys'"
  default     = null
}

