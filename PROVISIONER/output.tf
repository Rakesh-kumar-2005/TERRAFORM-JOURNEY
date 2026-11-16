output "instance_id" {
  value       = aws_instance.demo.id
  description = "Instance id of Demo"
}

output "public_ip" {
  description = "Public IP of the demo EC2 instance"
  value       = aws_instance.demo.public_ip
}