provider "aws" {
  region = "ap-south-1"
}

# ------------------------------
# 1. Create S3 bucket
# ------------------------------
resource "aws_s3_bucket" "static_website" {
  bucket = "balaji-static-website-bucket-12345"  # must be globally unique
}

# ------------------------------
# 2. Public access configuration
# ------------------------------
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ------------------------------
# 3. Bucket policy (public read)
# ------------------------------
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

# ------------------------------
# 4. Website configuration (new style)
# ------------------------------
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# ------------------------------
# 5. Upload HTML files
# ------------------------------
resource "aws_s3_object" "html_files" {
  for_each = fileset("${path.module}", "*.html")

  bucket       = aws_s3_bucket.static_website.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/html"
}

# ------------------------------
# 6. Upload CSS files
# ------------------------------
resource "aws_s3_object" "css_files" {
  for_each = fileset("${path.module}", "*.css")

  bucket       = aws_s3_bucket.static_website.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "text/css"
}

# ------------------------------
# 7. Upload JS files
# ------------------------------
resource "aws_s3_object" "js_files" {
  for_each = fileset("${path.module}", "*.js")

  bucket       = aws_s3_bucket.static_website.id
  key          = each.value
  source       = "${path.module}/${each.value}"
  etag         = filemd5("${path.module}/${each.value}")
  content_type = "application/javascript"
}


