# Variables Configuration

variable "project_name" {
  description = "The ID of the project in which to create resources."
  type        = string
  default     = "two-tier-app"
}

variable "environment" {
  description = "The environment in which to create resources."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "The AWS region in which to create resources."
  type        = string
  default     = "us-east-1"
}

# VPC variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet for the vpc"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidrs" {
  description = "Private Subnets for the VPC"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

# EC2 variables
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# RDS variables
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "webappdb"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
}

variable "db_instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated Storage for RDS in GB"
  type        = number
  default     = 10
}

variable "db_engine_version" {
  description = "Database (MySQL) engine version"
  type        = string
  default     = "8.0"
}
