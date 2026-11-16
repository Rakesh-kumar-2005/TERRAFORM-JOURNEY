variable "aws_region" {
  default = "us-east-1"
  type    = string
  description = "Region for deploying the application"
}

variable "environment" {
  description = "Environment name"
  type = string
  default = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type = string
  default = "image-processor"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in second"
  type = number
  default = 60
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in mb"
  type = number
  default = 1024
}

variable "allowed_origins" {
  description = "Allowed CORS origins"
  type = list(string)
  default = [ "*" ]
}