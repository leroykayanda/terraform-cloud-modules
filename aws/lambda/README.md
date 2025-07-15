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
| [aws_cloudwatch_dashboard.dash](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_log_group.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_metric_alarm.errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_retention"></a> [cloudwatch\_log\_retention](#input\_cloudwatch\_log\_retention) | In days | `number` | `30` | no |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment eg prod, dev | `string` | n/a | yes |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables) | Map of environment variables that are accessible from the function code during execution | `map(any)` | `{}` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | The size of the Lambda function Ephemeral storage(/tmp) represented in MB. The minimum supported ephemeral\_storage value defaults to 512MB and the maximum supported value is 10240MB. | `number` | `512` | no |
| <a name="input_iam_role"></a> [iam\_role](#input\_iam\_role) | Amazon Resource Name (ARN) of the function's execution role. The role provides the function's identity and access to AWS services and resources. | `string` | n/a | yes |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | ECR image URI containing the function's deployment package. Exactly one of filename, image\_uri, or s3\_bucket must be specified. | `string` | `null` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime | `number` | `128` | no |
| <a name="input_needs_vpc"></a> [needs\_vpc](#input\_needs\_vpc) | n/a | `bool` | `false` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | Lambda deployment package type. Valid values are Zip and Image | `string` | `"Image"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | n/a | `string` | `null` | no |
| <a name="input_service"></a> [service](#input\_service) | Name of the ECS service | `string` | n/a | yes |
| <a name="input_sns_topic"></a> [sns\_topic](#input\_sns\_topic) | For alarms | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | To tag resources. | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Amount of time your Lambda Function has to run in seconds. | `number` | `900` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->