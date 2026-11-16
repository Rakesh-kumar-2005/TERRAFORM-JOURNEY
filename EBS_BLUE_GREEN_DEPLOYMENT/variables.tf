variable "aws_region" {
  description = "AWS region to deploy resources in"
  type = string
  default = "us-east-1"
}

variable "app_name" {
  description = "Name of the elastic beanstalk application"
  type = string
  default = "my-app-buegreeen"
}

variable "solution_stack_name" {
  description = "Elastic Beanstalk Solution stack name"
  type = string
  default = "64bit Amazon Linux 2023 v6.11.7 running Node.js 22"
}

variable "instance_type" {
  description = "EC2 instance type for Elastic Beanstalk Environments"
  type = string
  default = "t3.micro"
}

variable "tags" {
  description = "tags to apply to all resources"
  type = map(string)
  default = {
    Project = "BlueGreenDeployment"
    Environment = "Demo"
    ManagedBy = "Terraform"
  }
}

data "aws_caller_identity" "current" {}