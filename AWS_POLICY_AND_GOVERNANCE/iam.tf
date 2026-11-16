# iam.tf
# -------------------------------------------------------
# 1. IAM policy Examples
# -------------------------------------------------------

# Create a custom IAM policy for AWS Config to access the S3 bucket
resource "aws_iam_policy" "mfa-delete-policy" {
  name        = "${var.project_name}-mfa-delete-policy"
  description = "Policy that requires MFA to delete S3 Objects in the config bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyDeleteWithoutMFA"
        Effect   = "Deny"
        Action   = "s3:deleteObject"
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# IAM Policy : Enforce encryption in transit and at rest for S3 bucket
resource "aws_iam_policy" "enforce_s3_encryption_transit" {
  name        = "${var.project_name}-enforce-s3-encryption-transit"
  description = "Policy that enforces encryption in transit and at rest for S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyUnencryptedObjectUploads"
        Effect   = "Deny"
        Action   = "s3:PutObject"
        Resource = "*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# IAM Policy: Require tagging for resource creation
resource "aws_iam_policy" "require_tag_policy" {
  name        = "${var.project_name}-require-tag"
  description = "Policy that requires specific for creating resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "RequiredTagsOnEC2"
        Effect = "Deny"
        Action = [
          "ec2:RunInstances",
        ]
        Resource = "arn:aws:ec2:*:*:instance/*"
        Condition = {
          StringNotEqualsIfExists = {
            "aws:RequestTag/Environment" = ["dev", "prod", "staging"]
          }
        }
      },
      {
        Sid    = "RequiredOwnerTags"
        Effect = "Deny"
        Action = [
          "ec2:RunInstances",
        ]
        Resource = "arn:aws:ec2:*:*:instance/*"
        Condition = {
          "Null" = {
            "aws:RequestTag/Owner" = "true"
          }
        }
      }
    ]
  })
}


# IAM user for Demonstration purpose
resource "aws_iam_user" "demo_user" {
  name = "${var.project_name}-demo-user"
  path = "/governance/"

  tags = {
    Environment = "demo"
    Purpose     = "governance-training"
  }
}

# Attach MFA policy to demo user
resource "aws_iam_user_policy_attachment" "mfa_attachment" {
  user       = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.mfa-delete-policy.arn
}

# ---------------------------------------------------------------
# 2. IAM role for AWS COnfig
# ---------------------------------------------------------------

# IAM role
resource "aws_iam_role" "config_role" {
  name = "${var.project_name}-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })
}

# Attach managed policy to Config role
resource "aws_iam_role_policy_attachment" "config_policy_attach" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

# Additional Policy for config to write to S3
resource "aws_iam_role_policy" "config_s3_policy" {
  name = "${var.project_name}-config-s3-policy"
  role = aws_iam_role.config_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid     = "ConfigS3Access"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:GetBucketVersioning",
        ]
        Resource = [
          "${aws_s3_bucket.config_bucket.arn}/*",
          aws_s3_bucket.config_bucket.arn
        ]
      }
    ]
  })
}
