variable "aws_region" {
  description = "AWS Region for Resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for the resources"
  type        = string
  default     = "terraform-governance-demo"
}