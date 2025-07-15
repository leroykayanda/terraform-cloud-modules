variable "service" {
  type        = string
  description = "Name of the service"
}

variable "env" {
  type        = string
  description = "Deployment environment eg prod, dev"
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "images_to_keep" {
  type        = number
  default     = 10
  description = "policy for how many images to keep in ECR repository"
}
