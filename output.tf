output "s3_bucket_website_url" {
  description = "The S3 bucket static website URL"
  value       = module.s3.bucket_website_url
}

output "cloudfront_domain_name" {
  description = "The CloudFront distribution domain name"
  value       = module.cloudfront.domain_name
}

output "custom_domain_name" {
  description = "The custom domain name for the Angular application"
  value       = module.route53.domain_name
}
