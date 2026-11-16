# --------------------------------------------------------------
# AWS Config Recorder and Delivery Channel
# --------------------------------------------------------------

# AWS Config Recorder
resource "aws_config_configuration_recorder" "main" {
  name     = "${var.project_name}-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

# AWS config Delivery Channel
resource "aws_config_delivery_channel" "main" {
  name           = "${var.project_name}-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket

  depends_on = [
    aws_config_configuration_recorder.main
  ]
}

# start the config recorder
resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.main]
}

# --------------------------------------------------------------
# AWS Config Rules - Compliance checks
# --------------------------------------------------------------

# Config Rule: Ensure S3 buckets don't allow public writes
resource "aws_config_config_rule" "s3_public_write_prohibited" {
  name = "s3-bucket-public-write-prohibited"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Configuration Rule: Ensure S3 buckets don't allow public reads
resource "aws_config_config_rule" "s3_public_read_prohibited" {
  name = "s3-bucket-public-read-prohibited"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Configuration Rule: EBS encryption should be enabled
resource "aws_config_config_rule" "ebs_encryption_enabled" {
  name = "ebs-encryption-enabled"
  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Configuration Rule: Ensure EC2 instances have required tags
resource "aws_config_config_rule" "required_tags" {
  name = "required_tags"
  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = jsonencode({
    tag1Key = "Environment"
    tag2Key = "Owner"
  })

  scope {
    compliance_resource_types = [
      "AWS::EC2::Instance",
      "AWS::S3::Bucket"
    ]
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# Configuration Rule: Ensure IAM users have MFA enabled
resource "aws_config_config_rule" "root_mfa_enabled" {
  name = "root-account-mfa_enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.main]

}
