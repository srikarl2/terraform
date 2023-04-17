# Define input variables
variable "bucket_name" {
  type        = string
  description = "Name for the S3 bucket"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the CloudFront distribution"
}

variable "logging_bucket_name" {
  type        = string
  description = "Name for the S3 bucket to store CloudFront logs"
}
