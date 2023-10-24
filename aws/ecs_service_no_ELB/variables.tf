
variable "service_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "cluster_arn" {
  type        = string
  description = "ARN of cluster to add this service to"
}

variable "task_execution_role" {
  type = string
}

variable "fargate_cpu" {
  type        = number
  description = "Number of cpu units used by a Fargate task"
  default     = 1
}

variable "fargate_mem" {
  type        = number
  description = "Amount (in MiB) of memory used by the task"
  default     = 2048
}

variable "container_name" {
  type        = string
  description = "Name of the container"
}

variable "container_image" {
  type = string
}

variable "task_environment_variables" {
  type    = list(map(string))
  default = []
}

variable "task_secret_environment_variables" {
  type    = list(map(string))
  default = []
}

variable "region" {
  type = string
}

variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "desired_count" {
  type        = string
  description = "Desired number of tasks"
}

variable "capacity_provider" {
  type        = string
  description = "Fargate"
}

variable "task_subnets" {
  type        = list(string)
  description = "Private subnets to be used to launch the ECS tasks"
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "min_capacity" {
  type        = number
  description = "Minimum no. of tasks"
}

variable "max_capacity" {
  type        = number
  description = "Maximum no. of tasks"
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "sns_topic" {
  type        = string
  description = "SNS topic ARN for notifications"
  default     = ""
}

variable "team" {
  type        = string
  description = "Used to tag resources"
}

variable "command" {
  type    = list(string)
  default = []
}


variable "entrypoint" {
  type    = list(string)
  default = []
}

variable "user" {
  type    = string
  default = null
}

variable "task_sg" {
  type        = string
  description = "Task security group"
}

variable "portMappings" {
  type    = list(map(string))
  default = []
}

variable "create_volume" {
  type        = string
  description = "yes or no - conrols whether the task has a volume or not"
  default     = "no"
}

variable "volume_name" {
  type        = string
  description = "Name of the volume"
  default     = ""
}

variable "file_system_id" {
  type        = string
  description = "EFS"
  default     = ""
}

variable "mountPoints" {
  type        = list(map(string))
  description = "EFS"
  default     = []
}

variable "access_point_id" {
  type        = string
  description = "EFS"
  default     = ""
}
