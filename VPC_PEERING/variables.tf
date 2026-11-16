variable "primary_region" {
  description = "The Primary region..."
  default     = "us-east-1"
  type        = string
}

variable "secondary_region" {
  description = "The Secondary region..."
  default     = "us-east-2"
  type        = string
}

variable "primary_vpc_cidr" {
  description = "CIDR block for the primary region"
  default     = "10.0.0.0/16"
  type        = string
}

variable "secondary_vpc_cidr" {
  description = "CIDR block for the secondary region"
  default     = "10.1.0.0/16"
  type        = string
}

variable "primary_subnet_cidr" {
  description = "Subnet for the Primary CIDR"
  default     = "10.0.1.0/24"
  type        = string
}

variable "secondary_subnet_cidr" {
  description = "Subnet for the Secondary CIDR"
  default     = "10.1.1.0/24"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instances"
  default     = "t3.micro"
  type        = string
}

variable "key_name" {
  description = "The Key-Pair for SSH"
  default     = "vpc-peering-demo"
  type        = string
}