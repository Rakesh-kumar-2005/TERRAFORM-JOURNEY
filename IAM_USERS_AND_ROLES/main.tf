# Get the aws account ID of the current user
data "aws_caller_identity" "current" {}

# output the account ID
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# Read users from the users.csv file
locals {
  users = csvdecode(file("users.csv"))
}

# output the usernames
output "usernames" {
  value = [for user in local.users : "${user.first_name} ${user.last_name}"]
}

# Creating IAM users based on the users.csv file
resource "aws_iam_user" "users" {
  for_each = {for user in local.users : user.first_name => user}

  name = lower("${each.value.first_name}_${each.value.last_name}")
  path = "/users/"

  tags = {
    "DisplayName" = "${each.value.first_name} ${each.value.last_name}"
    "Department" = each.value.department
    "JobTitle" = each.value.job_title
  }
}

# Create IAM user login profiles for each user
resource "aws_iam_user_login_profile" "users" {
  for_each = aws_iam_user.users

  user = each.value.name
  password_reset_required = true

  lifecycle {
    ignore_changes = [ 
        password_length,
        password_reset_required
     ]
  }
}

output "user_passwords" {
  value = {
    for user, profile in aws_iam_user_login_profile.users :
    user => "Password for ${user} is set and must be reset on first login."
  }
}