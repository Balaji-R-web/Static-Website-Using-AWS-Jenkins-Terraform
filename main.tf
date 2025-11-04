provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name
  

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name = "StaticWebsiteBucket"
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["${aws_s3_bucket.static_site.arn}/*"]
      }
    ]
  })
}

resource "aws_s3_bucket_object" "website_files" {
  for_each = fileset("${path.module}/website", "*")

  bucket       = aws_s3_bucket.static_site.bucket
  key          = each.value
  source       = "${path.module}/website/${each.value}"
  etag         = filemd5("${path.module}/website/${each.value}")
  content_type = "text/html"
}
