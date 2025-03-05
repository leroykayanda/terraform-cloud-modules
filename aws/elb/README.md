<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_access_logs_bucket"></a> [access\_logs\_bucket](#module\_access\_logs\_bucket) | terraform-aws-modules/s3-bucket/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.listener_443_fixed_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.listener_443_forward](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.redirect](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | SSL cert | `string` | n/a | yes |
| <a name="input_client_keep_alive"></a> [client\_keep\_alive](#input\_client\_keep\_alive) | The value you choose specifies the maximum amount of time a client connection can remain open, regardless of the activity on the connection. The client keep alive duration begins when the connection is initially established and does not reset. When the client keep alive duration period has elapsed, the load balancer closes the connection. Valid range is 60 - 604800 seconds. The default is 3600 seconds, or 1 hour. | `number` | `3600` | no |
| <a name="input_company_name"></a> [company\_name](#input\_company\_name) | To make the ELB access log bucket name unique | `string` | `""` | no |
| <a name="input_create_access_logs_bucket"></a> [create\_access\_logs\_bucket](#input\_create\_access\_logs\_bucket) | Whether to create ELB access logs bucket or not | `bool` | `true` | no |
| <a name="input_elb_access_log_expiration"></a> [elb\_access\_log\_expiration](#input\_elb\_access\_log\_expiration) | Days after which to delete ELB access logs | `number` | `30` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Whether HTTP/2 is enabled in application load balancers. Defaults to true. | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the environment | `string` | n/a | yes |
| <a name="input_existing_access_logs_bucket"></a> [existing\_access\_logs\_bucket](#input\_existing\_access\_logs\_bucket) | An existing ELB access logs bucket. Leave as blank if none exists. | `string` | `""` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | Time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60. | `number` | `60` | no |
| <a name="input_ingress_ports"></a> [ingress\_ports](#input\_ingress\_ports) | Which ports should be allowed inbound | `list(number)` | <pre>[<br/>  80,<br/>  443<br/>]</pre> | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, the LB will be internal. Defaults to false. | `bool` | `false` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of load balancer to create. Possible values are application, gateway, or network. The default value is application. | `string` | `"application"` | no |
| <a name="input_service"></a> [service](#input\_service) | Name of the application | `string` | n/a | yes |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Policy ELB listener will use | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs to attach to the LB. For Load Balancers of type network subnets can only be added (see Availability Zones), deleting a subnet for load balancers of type network will force a recreation of the resource. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_target_group_details"></a> [target\_group\_details](#input\_target\_group\_details) | Details to use when creating a target group | `map(string)` | <pre>{<br/>  "application_port": 443,<br/>  "create_target_group": true,<br/>  "deregistration_delay": "30",<br/>  "health_check_matcher": "200",<br/>  "health_check_path": "/",<br/>  "health_check_protocol": "HTTPS",<br/>  "protocol": "HTTPS",<br/>  "protocol_version": "HTTP1"<br/>}</pre> | no |
| <a name="input_use_access_logs_bucket_prefix"></a> [use\_access\_logs\_bucket\_prefix](#input\_use\_access\_logs\_bucket\_prefix) | S3 bucket prefix. Logs are stored in the root if not configured. Set to true to set prefix as var.env-var.service | `bool` | `false` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->