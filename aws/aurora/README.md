<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_dashboard.dash](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_cloudwatch_metric_alarm.acu_usage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.buffer_cache_hit_ratio](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.disk_queue_depth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.freeable_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.rds_CPUUtilization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.read_latency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.write_latency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_parameter_group.db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.cluster_instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_db_cluster_snapshot.snapshot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_cluster_snapshot) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Enable to allow major engine version upgrades when changing engine versions | `bool` | `false` | no |
| <a name="input_aurora_settings"></a> [aurora\_settings](#input\_aurora\_settings) | n/a | `map(any)` | <pre>{<br/>  "backup_retention_period": 35,<br/>  "buffer_cache_hit_ratio_alarm_threshold": 80,<br/>  "db_instance_count": 2,<br/>  "disk_queue_depth_alarm_threshold": 200,<br/>  "engine": "aurora-postgresql",<br/>  "engine_mode": "provisioned",<br/>  "engine_version": "16.1",<br/>  "freeable_memory_alarm_threshold": 2000000000,<br/>  "instance_class": "db.serverless",<br/>  "parameter_group_family": "aurora-postgresql16",<br/>  "performance_insights_retention_period": 31,<br/>  "port": 5432,<br/>  "publicly_accessible": false,<br/>  "serverless_cluster": true,<br/>  "serverless_max_capacity": "8",<br/>  "serverless_min_capacity": "0.5"<br/>}</pre> | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | For Aurora | `list(string)` | <pre>[<br/>  "af-south-1a",<br/>  "af-south-1b",<br/>  "af-south-1c"<br/>]</pre> | no |
| <a name="input_db_cluster_snapshot_identifier"></a> [db\_cluster\_snapshot\_identifier](#input\_db\_cluster\_snapshot\_identifier) | Name of the snapshort we are restoring | `string` | `null` | no |
| <a name="input_db_credentials"></a> [db\_credentials](#input\_db\_credentials) | Db user and password | `map(string)` | <pre>{<br/>  "db_name": "",<br/>  "password": "",<br/>  "user": ""<br/>}</pre> | no |
| <a name="input_db_subnets"></a> [db\_subnets](#input\_db\_subnets) | Subnets to create the db in | `list(string)` | n/a | yes |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | n/a | `list(string)` | <pre>[<br/>  "postgresql"<br/>]</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | Deployment environment eg prod, dev | `string` | n/a | yes |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | n/a | `string` | `"02:00-03:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | n/a | `string` | `"sun:00:00-sun:01:00"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_restoring_snaphot"></a> [restoring\_snaphot](#input\_restoring\_snaphot) | Are you restoring DB from a snapshot | `bool` | `false` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | n/a | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Name of the service | `string` | n/a | yes |
| <a name="input_snapshot_cluster"></a> [snapshot\_cluster](#input\_snapshot\_cluster) | Cluster whose snapshot we are using | `string` | `null` | no |
| <a name="input_sns_topic"></a> [sns\_topic](#input\_sns\_topic) | SNS topic ARN for notifications | `string` | n/a | yes |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Specifies the storage type to be associated with the DB cluster. Valid values are: "", aurora-iopt1 (Aurora DB Clusters) | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | To tag resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_id"></a> [aurora\_id](#output\_aurora\_id) | n/a |
| <a name="output_aurora_writer_endpoint"></a> [aurora\_writer\_endpoint](#output\_aurora\_writer\_endpoint) | n/a |
<!-- END_TF_DOCS -->