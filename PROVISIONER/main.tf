terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Getting the latest ubuntu ami id for the region
data "aws_ami" "ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "tf-prov-demo-ssh"
  description = "Allowing the SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "demo" {
  ami             = data.aws_ami.ubuntu.id
  key_name        = var.key_name
  instance_type   = var.instance_type
  security_groups = [aws_security_group.ssh.name]

  tags = {
    Name = "Terraform_provisioner-demo"
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

#   Provisioner 1 :- Local-exec provisioner to run a local command on the machine where Terraform is being executed. In this case, it runs the 'echo' command to print a message indicating that the instance has been created successfully.

#   provisioner "local-exec" {
#     command = "echo Instance ${self.id} with public IP ${self.public_ip} has been created successfully!"
#   }

#   Provisioner 2 :- Remote-exec provisioner to run commands on the remote instance after it has been created. In this case, it runs a series of commands to update the package list, install Nginx, and start the Nginx service.
#   It will print the message and all the instruction on the same machine as terraform is being executed. It will not print the message on the remote instance.

#   provisioner "remote-exec" {
#     inline = [ 
#         "sudo apt-get update",
#         "echo 'Hello from the remote-exec' | sudo tee /tmp/remote_exec.txt"
        
#      ]
#   }

#   Provisioner 3 :- File provisioner to copy a file from the local machine to the remote instance. In this case, it copies a local file named 'local_file.txt' to the '/tmp/remote_file.txt' path on the remote instance.

  provisioner "file" {
    source = "${path.module}/scripts/welcome.sh"
    destination = "/tmp/welcome.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "sudo chmod +x /tmp/welcome.sh",
        "sudo /tmp/welcome.sh"
     ]
  }


}
