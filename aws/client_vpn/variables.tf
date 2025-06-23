variable "vpc_id" {
  type = string
}

variable "description" {
  type        = string
  description = "A brief description of the Client VPN endpoint."
}

variable "client_cidr_block" {
  type        = string
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range cannot be changed after the Client VPN endpoint has been created. The CIDR block should be /22 or greater."
}

variable "server_certificate_arn" {
  type        = string
  description = "The ARN of the ACM server certificate."
}

variable "active_directory_id" {
  type        = string
  description = "The ID of the Active Directory to be used for authentication if type is directory-service-authentication."
  default     = null
}

variable "saml_provider_arn" {
  type        = string
  description = "The ARN of the IAM SAML identity provider if type is federated-authentication"
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  description = "The IDs of one or more security groups to apply to the target network. You must also specify the ID of the VPC that contains the security groups."
}

variable "subnet_ids" {
  type        = list(string)
  description = "The identifiers of the subnets for the VPN endpoint"
}

# Optional

variable "tags" {
  type    = map(string)
  default = {}
}

variable "authentication_type" {
  type        = string
  description = "The type of client authentication to be used. Specify certificate-authentication to use certificate-based authentication, directory-service-authentication to use Active Directory authentication, or federated-authentication to use Federated Authentication via SAML 2.0."
}

variable "dns_servers" {
  type        = list(string)
  description = "Information about the DNS servers to be used for DNS resolution. A Client VPN endpoint can have up to two DNS servers. If no DNS server is specified, the DNS address of the connecting device is used."
  default     = []
}

variable "split_tunnel" {
  type        = bool
  description = "Indicates whether split-tunnel is enabled on VPN endpoint. Default value is false"
  default     = false
}

variable "self_service_portal" {
  type        = string
  description = "Specify whether to enable the self-service portal for the Client VPN endpoint. Values can be enabled or disabled. Default value is disabled."
}

variable "session_timeout_hours" {
  type        = number
  description = "The maximum session duration is a trigger by which end-users are required to re-authenticate prior to establishing a VPN session. Default value is 24 - Valid values: 8 | 10 | 12 | 24"
  default     = 8
}

variable "target_network_cidrs" {
  type        = list(string)
  description = "CIDRs to add in authorization rules"
}
