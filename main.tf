provider "aws" {
  region = "ap-south-1" # change to your region
}

# Create S3 bucket
resource "aws_s3_bucket" "static_website" {
  bucket = "balaji-static-website-bucket-12345"  # change bucket name (must be globally unique)
}

# Enable public access for website hosting
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Allow public read access to objects
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Upload all website files
resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}", "*.html")

  bucket       = aws_s3_bucket.static_website.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_object" "css_files" {
  for_each = fileset("${path.module}", "*.css")

  bucket       = aws_s3_bucket.static_website.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/css"
}

resource "aws_s3_object" "js_files" {
  for_each = fileset("${path.module}", "*.js")

  bucket       = aws_s3_bucket.static_website.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "application/javascript"
}

# Output the website URL
output "website_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}
