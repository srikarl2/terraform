# required_providers {
#   aws = {
#     source = "hashicorp/aws"
#     version = "~> 3.0"
#     configurations = ["local"]
#   }

# Create a Route53 DNS record for the CloudFront distribution
resource "aws_route53_record" "cloudfront" {
  count = var.enabled ? 1 : 0

  zone_id = data.aws_route53_zone.main.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.target_hostname
    zone_id                = data.aws_route53_zone.main.id
    evaluate_target_health = true
  }
}

# Retrieve the Route53 hosted zone for the domain
data "aws_route53_zone" "main" {
  name = var.domain_name
}

# Define input variables
variable "domain_name" {
  type        = string
  description = "Domain name for the CloudFront distribution"
}

variable "target_hostname" {
  type        = string
  description = "Hostname for the CloudFront distribution"
}

variable "enabled" {
  type        = bool
  description = "Whether to create a Route53 entry for the CloudFront distribution"
  default     = true
}
