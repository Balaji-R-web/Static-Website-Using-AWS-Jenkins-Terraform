output "bucket_name" {
  description = "Bucket name hosting your website."
  value       = aws_s3_bucket.site.bucket
}

output "website_endpoint" {
  description = "S3 Website Endpoint (HTTP)."
  value       = aws_s3_bucket_website_configuration.site.website_endpoint
}
