terraform {
  required_version = ">= 1.0.0, < 2.0.0"
}


# provider "aws" {
#   version = "~> 3.0"
#   plugins {
#     local = {
#       directory = "${path.module}/../provider-plugins/"
#     }
#   }
# }



# Create the S3 bucket
module "s3" {
  source = "./modules/s3_bucket"

  bucket_name = var.bucket_name
}

# Create the IAM role for CloudFront
module "iam" {
  source = "./modules/iam"

  s3_bucket_arn = module.s3.bucket_arn
}

# Create the ACM certificate
module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
}

# Create the CloudFront distribution
module "cloudfront" {
  source = "./modules/cloudfront"

  s3_origin_id           = "s3_origin"
  s3_bucket_domain_name  = module.s3.bucket_name
  certificate_arn        = module.acm.certificate_arn
  logging_bucket_name    = var.logging_bucket_name
  origin_access_identity = module.cloudfront_origin_access_identity.cloudfront_origin_access_identity_iam_id
}

# Create the Route53 entry for the CloudFront distribution
# module "route53" {
#   source = "./route53"

#   domain_name     = var.domain_name
#   cloudfront_arn  = module.cloudfront.cloudfront_arn
#   target_hostname = module.cloudfront.cloudfront_domain_name
#   enabled         = var.route53_enabled
# }
