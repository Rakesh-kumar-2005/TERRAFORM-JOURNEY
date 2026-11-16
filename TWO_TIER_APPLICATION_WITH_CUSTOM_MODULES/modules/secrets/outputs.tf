# Secret Module :- Outputs

output "db_password" {
  description = "The database password stored in AWS Secrets Manager."
  value       = random_password.db_password.result
  sensitive   = true
}

output "secret_arn" {
  description = "The ARN of the secret in AWS Secrets Manager."
  value       = aws_secretsmanager_secret.db_password.arn
}