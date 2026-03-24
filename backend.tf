terraform {
  backend "s3" {
    bucket         = "sp-01102026-aws-kub" # Replace with your bucket name
    key            = "grafana/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    # 2026 Feature: Native S3 locking (No DynamoDB needed)
    use_lockfile   = true 
  }
}