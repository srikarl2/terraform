resource "aws_s3_bucket" "angular_app" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket_policy" "angular_app_policy" {
  bucket = aws_s3_bucket.angular_app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
        Principal = "*"
      }
    ]
  })
}
