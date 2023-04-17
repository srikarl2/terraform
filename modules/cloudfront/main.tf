# required_providers {
#   aws = {
#     source = "hashicorp/aws"
#     version = "~> 3.0"
#     configurations = ["local"]
#   }
# }

resource "aws_cloudfront_distribution" "distribution" {
  depends_on = [
    aws_iam_role_policy_attachment.s3_access,
    aws_acm_certificate_validation.cert_validation
  ]

  origin {
    domain_name = module.s3.bucket_name
    origin_id   = "s3_origin"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  # Viewer certificate
  viewer_certificate {
    acm_certificate_arn = module.acm.certificate_arn
    ssl_support_method  = "sni-only"
  }

  # Logging
  logging_config {
    include_cookies = false
    bucket          = var.logging_bucket_name
    prefix          = "cloudfront-logs/"
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl = 0
    max_ttl = 86400
    default_ttl = 3600
  }

  # Ordered cache behavior
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl = 0
    max_ttl = 31536000
    default_ttl = 86400
  }

  # Aliases
  aliases = [
    var.domain_name
  ]
}
