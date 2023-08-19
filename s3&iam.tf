# S3 bucket to store Terraform state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-wordpress-us-east-1"
  acl    = "private"
  versioning {
    enabled = true
  }
}


data "aws_iam_user" "terraform_user" {
  user_name = aws_iam_user.terraform_user.name
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Principal = {
          AWS = [data.aws_iam_user.terraform_user.arn]
        }
        Action   = ["s3:ListBucket"]
        Resource = [aws_s3_bucket.terraform_state.arn]
      },
      {
        Effect   = "Allow"
        Principal = {
          AWS = [data.aws_iam_user.terraform_user.arn]
        }
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = ["${aws_s3_bucket.terraform_state.arn}/*"]
      }
    ]
  })
}

# IAM user for Terraform
resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"
}

# IAM policy to allow the user to manage the Terraform state bucket
resource "aws_iam_policy" "terraform_policy" {
  name        = "TerraformS3Policy"
  description = "Policy to allow Terraform to access the S3 bucket for state files."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = [aws_s3_bucket.terraform_state.arn]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = ["${aws_s3_bucket.terraform_state.arn}/*"]
      }
    ]
  })
}

# Attach the policy to the user
resource "aws_iam_user_policy_attachment" "terraform_attachment" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}
