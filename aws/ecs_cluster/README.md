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
| [aws_autoscaling_group.ecs_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_metric_alarm.asg_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.asg_max_capacity_usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.asg_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.container_instance_count](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_ecs_capacity_provider.capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_cluster_capacity_providers.ec2_capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_launch_template.ecs_lt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_alarms"></a> [active\_alarms](#input\_active\_alarms) | Which alarms do you want to be created | `map(bool)` | <pre>{<br/>  "asg_cpu": true,<br/>  "asg_max_capacity_usage": true,<br/>  "asg_memory": true,<br/>  "container_instance_count": true<br/>}</pre> | no |
| <a name="input_alarm_periods"></a> [alarm\_periods](#input\_alarm\_periods) | n/a | `map(number)` | <pre>{<br/>  "asg_cpu": 900,<br/>  "asg_max_capacity_usage": 900,<br/>  "asg_memory": 900,<br/>  "container_instance_count": 300<br/>}</pre> | no |
| <a name="input_alarm_thresholds"></a> [alarm\_thresholds](#input\_alarm\_thresholds) | n/a | `map(number)` | <pre>{<br/>  "asg_cpu": 90,<br/>  "asg_max_capacity_usage": 90,<br/>  "asg_memory": 90<br/>}</pre> | no |
| <a name="input_asg_autoscaling_settings"></a> [asg\_autoscaling\_settings](#input\_asg\_autoscaling\_settings) | n/a | `map(string)` | <pre>{<br/>  "desired_capacity": 1,<br/>  "max_size": 2,<br/>  "min_size": 1<br/>}</pre> | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Should the container instances have public IPs | `bool` | `false` | no |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | EBS volume properties | `map(any)` | <pre>{<br/>  "device_name": "/dev/xvda",<br/>  "volume_size": 100,<br/>  "volume_type": "gp3"<br/>}</pre> | no |
| <a name="input_capacity_provider"></a> [capacity\_provider](#input\_capacity\_provider) | Short name of the ECS capacity provider. EC2 or FARGATE | `string` | `"EC2"` | no |
| <a name="input_cluster_autoscaling_settings"></a> [cluster\_autoscaling\_settings](#input\_cluster\_autoscaling\_settings) | n/a | `map(any)` | <pre>{<br/>  "managed_termination_protection": "ENABLED",<br/>  "maximum_scaling_step_size": 3,<br/>  "minimum_scaling_step_size": 1,<br/>  "target_capacity": 80<br/>}</pre> | no |
| <a name="input_container_insights"></a> [container\_insights](#input\_container\_insights) | enabled or disabled | `string` | `"enabled"` | no |
| <a name="input_default_cooldown"></a> [default\_cooldown](#input\_default\_cooldown) | n/a | `number` | `60` | no |
| <a name="input_default_instance_warmup"></a> [default\_instance\_warmup](#input\_default\_instance\_warmup) | n/a | `number` | `60` | no |
| <a name="input_enabled_metrics"></a> [enabled\_metrics](#input\_enabled\_metrics) | For the Autoscaling Group | `list(string)` | <pre>[<br/>  "GroupAndWarmPoolDesiredCapacity",<br/>  "GroupAndWarmPoolTotalCapacity",<br/>  "GroupDesiredCapacity",<br/>  "GroupInServiceCapacity",<br/>  "GroupInServiceInstances",<br/>  "GroupMaxSize",<br/>  "GroupMinSize",<br/>  "GroupPendingCapacity",<br/>  "GroupPendingInstances",<br/>  "GroupStandbyCapacity",<br/>  "GroupStandbyInstances",<br/>  "GroupTerminatingCapacity",<br/>  "GroupTerminatingInstances",<br/>  "GroupTotalCapacity",<br/>  "GroupTotalInstances",<br/>  "WarmPoolDesiredCapacity",<br/>  "WarmPoolMinSize",<br/>  "WarmPoolPendingCapacity",<br/>  "WarmPoolTerminatingCapacity",<br/>  "WarmPoolTotalCapacity",<br/>  "WarmPoolWarmedCapacity"<br/>]</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment eg prod, dev | `string` | n/a | yes |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | n/a | `number` | `300` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | EC2 or ELB | `string` | `"EC2"` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | Role that will be assumed by instances. | `string` | `null` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | AMI | `string` | `null` | no |
| <a name="input_instance_security_group"></a> [instance\_security\_group](#input\_instance\_security\_group) | SG Id | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"t3.medium"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | EC2 key pair name | `string` | `null` | no |
| <a name="input_service"></a> [service](#input\_service) | Name of the ECS service | `string` | n/a | yes |
| <a name="input_sns_topic"></a> [sns\_topic](#input\_sns\_topic) | n/a | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | To tag resources. | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | n/a | `any` | `null` | no |
| <a name="input_vpc_subnets"></a> [vpc\_subnets](#input\_vpc\_subnets) | For the Autoscaling Group | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->