# Secrets Manager :- variables

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment of the project"
  type = string
}

variable "db_username" {
  description = "Database username"
  type = string
}