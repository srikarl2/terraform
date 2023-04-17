terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "your-terraform-state-key"
    region         = "us-east-1"
    dynamodb_table = "your-terraform-state-locking-table"
  }
}