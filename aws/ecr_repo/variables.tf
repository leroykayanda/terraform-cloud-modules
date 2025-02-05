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
  default = "IMMUTABLE"
}

variable "images_to_keep" {
  type        = number
  description = "How many images will be kept by the lifecycle policy"
  default     = 10
}
