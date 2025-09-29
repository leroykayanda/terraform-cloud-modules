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
| [aws_cloudwatch_metric_alarm.cpu_high_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.freeable_memory_high_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.freeable_memory_low_urgency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_elasticache_replication_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Whether to enable encryption at rest | `bool` | `true` | no |
| <a name="input_auth_token_update_strategy"></a> [auth\_token\_update\_strategy](#input\_auth\_token\_update\_strategy) | Strategy to use when updating the auth\_token. Valid values are SET, ROTATE, and DELETE. Required if auth\_token is set. | `string` | `null` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported for engine types redis and valkey and if the engine version is 6 or higher. | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, num\_cache\_clusters must be greater than 1 | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | User-created description for the replication group. Must not be empty. | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | Name of the cache engine to be used for the clusters in this replication group. Valid values are redis or valkey. | `string` | `"redis"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version number of the cache engine to be used for the cache clusters in this replication group. | `string` | n/a | yes |
| <a name="input_high_urgency_alarm_thresholds"></a> [high\_urgency\_alarm\_thresholds](#input\_high\_urgency\_alarm\_thresholds) | n/a | `map(number)` | <pre>{<br/>  "cpu": 90,<br/>  "freeable_memory": 1000000000<br/>}</pre> | no |
| <a name="input_low_urgency_alarm_thresholds"></a> [low\_urgency\_alarm\_thresholds](#input\_low\_urgency\_alarm\_thresholds) | n/a | `map(number)` | <pre>{<br/>  "cpu": 80,<br/>  "freeable_memory": 2000000000<br/>}</pre> | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00 | `string` | `"sat:02:00-sat:03:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Specifies whether to enable Multi-AZ Support for the replication group | `bool` | `true` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance class to be used | `string` | n/a | yes |
| <a name="input_num_cache_clusters"></a> [num\_cache\_clusters](#input\_num\_cache\_clusters) | Number of cache clusters (primary and replicas) this replication group will have. If automatic\_failover\_enabled or multi\_az\_enabled are true, must be at least 2. Conflicts with num\_node\_groups and replicas\_per\_node\_group. | `number` | `"2"` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the parameter group to associate with this replication group. | `string` | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | Port number on which each of the cache nodes will accept connections | `number` | `6379` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group ids to apply to the cluster | `list(string)` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Name of the service | `string` | n/a | yes |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of snapshot\_retention\_limit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro cache nodes | `string` | n/a | yes |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00 | `string` | `"00:00-01:00"` | no |
| <a name="input_sns_topic"></a> [sns\_topic](#input\_sns\_topic) | For alarm notifications | `map(string)` | `null` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Name of the cache subnet group to be used for the replication group. | `string` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of VPC Subnet IDs for the cache subnet group | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Whether to enable encryption in transit. Changing this argument with an engine\_version < 7.0.5 will force a replacement. Engine versions prior to 7.0.5 only allow this transit encryption to be configured during creation of the replication group. | `bool` | `false` | no |
| <a name="input_world"></a> [world](#input\_world) | Deployment environment eg prod, dev | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->