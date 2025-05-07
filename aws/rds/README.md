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
| [aws_cloudwatch_metric_alarm.cpu_high_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.db_load_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.disk_queue_depth_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_storage_space_high_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_storage_space_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.freeable_memory_high_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.freeable_memory_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.iops_high_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.iops_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.oldest_replication_slot_lag_high_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.oldest_replication_slot_lag_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.read_latency_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.replica_lag_high_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.replica_lag_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.write_latency_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_instance.db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gibibytes. | `number` | `500` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for. Must be between 0 and 35. | `number` | `21` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled. Must not overlap with maintenance\_window.Eg: 00:00-02:00 | `string` | `"01:00-01:30"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the database to create when the DB instance is created. | `string` | `null` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | n/a | `string` | `null` | no |
| <a name="input_db_subnets"></a> [db\_subnets](#input\_db\_subnets) | subnets to create the db in | `list(string)` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | n/a | `string` | `null` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Specifies whether to remove automated backups immediately after the DB instance is deleted | `bool` | `false` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | n/a | `bool` | `true` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | Set of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine). MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace. eg ['postgresql'] | `list(string)` | <pre>[<br/>  "postgresql"<br/>]</pre> | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use eg. postgres, aurora-postgresql | `string` | `"postgres"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version to use | `string` | `"17.2"` | no |
| <a name="input_high_urgency_alarm_thresholds"></a> [high\_urgency\_alarm\_thresholds](#input\_high\_urgency\_alarm\_thresholds) | n/a | `map(number)` | <pre>{<br/>  "cpu": 100,<br/>  "free_storage_space": 1000000000000,<br/>  "freeable_memory": 10000000000,<br/>  "iops": 35000,<br/>  "oldest_replication_slot_lag": "300000000000",<br/>  "replica_lag": 1800<br/>}</pre> | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance. | `string` | n/a | yes |
| <a name="input_iops"></a> [iops](#input\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of io1 or io2 | `string` | n/a | yes |
| <a name="input_kms_key_deletion"></a> [kms\_key\_deletion](#input\_kms\_key\_deletion) | The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. | `number` | `30` | no |
| <a name="input_low_urgency_alarm_thresholds"></a> [low\_urgency\_alarm\_thresholds](#input\_low\_urgency\_alarm\_thresholds) | n/a | `map(number)` | <pre>{<br/>  "cpu": 85,<br/>  "db_load": 45,<br/>  "disk_queue_depth": 30,<br/>  "free_storage_space": 3000000000000,<br/>  "freeable_memory": 50000000000,<br/>  "iops": 30000,<br/>  "oldest_replication_slot_lag": "200000000000",<br/>  "read_latency": 0.5,<br/>  "replica_lag": 900,<br/>  "write_latency": 0.5<br/>}</pre> | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | n/a | `string` | `"Sun:03:00-Sun:03:30"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Specifies the maximum storage (in GiB) that Amazon RDS can automatically scale to for this DB instance. By default, Storage Autoscaling is disabled. To enable Storage Autoscaling, set max\_allocated\_storage to greater than or equal to allocated\_storage. Setting max\_allocated\_storage to 0 explicitly disables Storage Autoscaling. When configured, changes to allocated\_storage will be automatically ignored as the storage can dynamically scale. | `number` | `0` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data. Valid values are 7, 731 (2 years) or a multiple of 31 | `number` | `93` | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections. | `number` | `5432` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | n/a | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a Replica database, and to use this value as the source database | `string` | `null` | no |
| <a name="input_service"></a> [service](#input\_service) | Name of the service | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true | `bool` | `false` | no |
| <a name="input_sns_topic"></a> [sns\_topic](#input\_sns\_topic) | For alarm notifications | `map(string)` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted. | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of standard (magnetic), gp2 (general purpose SSD), gp3 (general purpose SSD that needs iops independently) io1 (provisioned IOPS SSD) or io2 (block express storage provisioned IOPS SSD) | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate. | `list(string)` | n/a | yes |
| <a name="input_world"></a> [world](#input\_world) | Deployment environment eg prod, dev | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_identifier"></a> [identifier](#output\_identifier) | n/a |
<!-- END_TF_DOCS -->