# https://cloudkatha.com/how-to-attach-an-iam-role-to-ec2-instance-using-terraform/

#Create an IAM Policy
# IAM -> Roles -> s3-read-only -> Permissions -> Permissions policies: [+] AmazonS3ReadOnlyAccess

resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3-Bucket-Access-Policy"
  description = "Provides permission to access S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "s3:Get*",
        "s3:List*",
      ]
      Resource = [
        "arn:aws:s3:::anpod07-rds/db_test.sql"
      ]
    },
    ]
  })
}

#Create an IAM Role
# IAM -> Roles -> s3-read-only -> Trust relationships: Trusted entities

resource "aws_iam_role" "s3_read_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

# Attach the Policy to the created IAM role
resource "aws_iam_policy_attachment" "s3_attach_policy_to_role" {
  name       = "s3_attach"
  roles      = [aws_iam_role.s3_read_role.name]
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

# Create an instance profile
resource "aws_iam_instance_profile" "s3_read_profile" {
  name = "s3_read_profile"
  role = aws_iam_role.s3_read_role.name
}

