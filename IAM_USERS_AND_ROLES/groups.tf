resource "aws_iam_group" "education" {
  name = "Education"
  path = "/groups/"
}

resource "aws_iam_group" "engineers" {
  name = "Engineers"
  path = "/groups/"
}

resource "aws_iam_group" "managers" {
  name = "Managers"
  path = "/groups/"
}

# Create IAM group memberships based on user tags
resource "aws_iam_group_membership" "education_membership" {
  name = "education-group-membership"
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Education"
  ]
}

# Create IAM group memberships for managers based on JobTitle tag
resource "aws_iam_group_membership" "manager_membership" {
  name = "manager-group-membership"
  group = aws_iam_group.managers.name

  users = [
    for user in aws_iam_user.users : user.name if contains(keys(user.tags), "JobTitle") && can(regex("Manager|CEO", user.tags.JobTitle))
  ]
}

# Create IAM group memberships for engineers based on Department tag
resource "aws_iam_group_membership" "engineer_membership" {
  name = "engineer-group-membership"
  group = aws_iam_group.engineers.name

  users = [
    for user in aws_iam_user.users : user.name if user.tags.Department == "Engineering"
  ]
}