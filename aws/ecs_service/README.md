<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_target.ecs_app_scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_dashboard.dash](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_log_group.cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.cloudwatch_log_group_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.pending_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.running_tasks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.service_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.service_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecs_service.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_listener_rule.rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ecr_image.ecr_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_image) | data source |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_cluster) | data source |
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_lb_listener.listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_listener) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_alarms"></a> [active\_alarms](#input\_active\_alarms) | Which alarms do you want to be created | `map(bool)` | <pre>{<br/>  "asg_max_capacity": true,<br/>  "pending_tasks": true,<br/>  "running_tasks": true,<br/>  "service_cpu": true,<br/>  "service_memory": true<br/>}</pre> | no |
| <a name="input_alarm_periods"></a> [alarm\_periods](#input\_alarm\_periods) | n/a | `map(number)` | <pre>{<br/>  "pending_tasks": 900,<br/>  "running_tasks": 300,<br/>  "service_cpu": 900,<br/>  "service_memory": 900<br/>}</pre> | no |
| <a name="input_alarm_thresholds"></a> [alarm\_thresholds](#input\_alarm\_thresholds) | n/a | `map(number)` | <pre>{<br/>  "service_cpu": 90,<br/>  "service_memory": 90<br/>}</pre> | no |
| <a name="input_cloudwatch_logs_retention"></a> [cloudwatch\_logs\_retention](#input\_cloudwatch\_logs\_retention) | In days | `number` | `30` | no |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | ARN of cluster to add this service to | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | n/a | yes |
| <a name="input_command"></a> [command](#input\_command) | Container CMD | `list(string)` | `[]` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container | `string` | n/a | yes |
| <a name="input_container_name_2"></a> [container\_name\_2](#input\_container\_name\_2) | Name of the second container | `any` | `null` | no |
| <a name="input_container_network_mode"></a> [container\_network\_mode](#input\_container\_network\_mode) | n/a | `string` | `"bridge"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port container listens on | `number` | n/a | yes |
| <a name="input_create_volume"></a> [create\_volume](#input\_create\_volume) | Attach EFS volume? | `bool` | `false` | no |
| <a name="input_ecr_repository"></a> [ecr\_repository](#input\_ecr\_repository) | Name of the ECR repo | `string` | n/a | yes |
| <a name="input_efs_access_point_id"></a> [efs\_access\_point\_id](#input\_efs\_access\_point\_id) | EFS accesspoint Id | `string` | `null` | no |
| <a name="input_efs_file_system_id"></a> [efs\_file\_system\_id](#input\_efs\_file\_system\_id) | EFS filesystem Id | `string` | `null` | no |
| <a name="input_efs_volume_name"></a> [efs\_volume\_name](#input\_efs\_volume\_name) | EFS volume name | `string` | `null` | no |
| <a name="input_entry_point"></a> [entry\_point](#input\_entry\_point) | Container Entrypoint | `list(string)` | `[]` | no |
| <a name="input_entry_point_2"></a> [entry\_point\_2](#input\_entry\_point\_2) | Container 2 Entrypoint | `list(string)` | `[]` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | n/a | `number` | `null` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Loadbalancer configuration details | `map(any)` | <pre>{<br/>  "health_check_path": "/",<br/>  "load_balancer_listener_rule_path": "/*",<br/>  "load_balancer_name": "",<br/>  "uses_load_balancer": false,<br/>  "vpc_id": null<br/>}</pre> | no |
| <a name="input_load_balancer_defaults"></a> [load\_balancer\_defaults](#input\_load\_balancer\_defaults) | Loadbalancer default configuration details | `map(any)` | <pre>{<br/>  "health_matcher": "200-499",<br/>  "health_protocol": "HTTP",<br/>  "load_balancer_listener_port": 443,<br/>  "target_group_deregistration_delay": 60,<br/>  "target_group_protocol": "HTTP",<br/>  "target_group_protocol_version": "HTTP1"<br/>}</pre> | no |
| <a name="input_logging_type"></a> [logging\_type](#input\_logging\_type) | cloudwatch or json-file | `string` | `"cloudwatch"` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | EFS mount point | `list(map(string))` | `[]` | no |
| <a name="input_platform_version"></a> [platform\_version](#input\_platform\_version) | Platform version on which to run your service. Only applicable for launch\_type set to FARGATE. Defaults to LATEST | `string` | `null` | no |
| <a name="input_port_mappings"></a> [port\_mappings](#input\_port\_mappings) | Port mappings allow containers to access ports on the host container instance to send or receive traffic. | `any` | `[]` | no |
| <a name="input_port_mappings_2"></a> [port\_mappings\_2](#input\_port\_mappings\_2) | Port mappings for the second container | `any` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_service"></a> [service](#input\_service) | Name of the ECS service | `string` | n/a | yes |
| <a name="input_service_autoscaling_settings"></a> [service\_autoscaling\_settings](#input\_service\_autoscaling\_settings) | n/a | `map(number)` | <pre>{<br/>  "desired_count": 1,<br/>  "max_capacity": 5,<br/>  "min_capacity": 1<br/>}</pre> | no |
| <a name="input_sns_topic"></a> [sns\_topic](#input\_sns\_topic) | For alarm notifications | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_task_environment_variables"></a> [task\_environment\_variables](#input\_task\_environment\_variables) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_task_execution_role"></a> [task\_execution\_role](#input\_task\_execution\_role) | Task IAM role | `string` | n/a | yes |
| <a name="input_task_launch_type"></a> [task\_launch\_type](#input\_task\_launch\_type) | EC2 or FARGATE | `string` | `"EC2"` | no |
| <a name="input_task_resources"></a> [task\_resources](#input\_task\_resources) | Hard limit for container CPU and Memory | `map(number)` | <pre>{<br/>  "cpu": 256,<br/>  "memory": 512<br/>}</pre> | no |
| <a name="input_task_secret_environment_variables"></a> [task\_secret\_environment\_variables](#input\_task\_secret\_environment\_variables) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_task_security_group"></a> [task\_security\_group](#input\_task\_security\_group) | Task security group. Only valid for FARGATE. | `string` | `null` | no |
| <a name="input_task_subnets"></a> [task\_subnets](#input\_task\_subnets) | Subnets to be used to launch the ECS tasks. Only valid for FARGATE. | `list(string)` | `[]` | no |
| <a name="input_two_containers"></a> [two\_containers](#input\_two\_containers) | Does the task definition have two containers | `bool` | `false` | no |
| <a name="input_user"></a> [user](#input\_user) | Container user ID | `string` | `null` | no |
| <a name="input_world"></a> [world](#input\_world) | Deployment environment eg prod, dev | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_appautoscaling_target_resource_id"></a> [aws\_appautoscaling\_target\_resource\_id](#output\_aws\_appautoscaling\_target\_resource\_id) | n/a |
<!-- END_TF_DOCS -->