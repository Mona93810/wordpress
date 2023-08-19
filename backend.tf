 terraform {
  backend "s3" {
    bucket = "wordpress-assessment-us-east-1"
    key    = "environment/dev/terraform.tfstate"
    region = "us-east-1"
    profile = "default"
  }
} 

