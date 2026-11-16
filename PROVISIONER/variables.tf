variable "instance_type" {
  description = "EC2 Instance type"
  default     = "t3.micro"
  type        = string
}

# Keyname would be - terraform-demo-key
variable "key_name" {
  description = "Name of ab existing EC2 key pair"
  type        = string
  default = "terraform-demo-key"
}

# Path: same folder as the terraform code
variable "private_key_path" {
  description = "Path to the private key file for SSH"
  type        = string
  default     = "./terraform-demo-key.pem"
}

variable "ssh_user" {
  description = "SSH username for the AMI"
  type        = string
  default     = "ubuntu"
}
