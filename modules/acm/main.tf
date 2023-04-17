# required_providers {
#   aws = {
#     source = "hashicorp/aws"
#     version = "~> 3.0"
#     configurations = ["local"]
#   }
# }

resource "aws_acm_certificate" "angular_app_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Terraform = "true"
  }
}

resource "aws_acm_certificate_validation" "angular_app_cert_validation" {
  certificate_arn         = aws_acm_certificate.angular_app_cert.arn
  validation_record_fqdns = aws_route53_record.cert_validation.*.fqdn
}
