output "website_url" {
  description = "URL HTTPS website (CloudFront)."
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}

output "bucket_name" {
  description = "Nama bucket S3 origin."
  value       = aws_s3_bucket.site.id
}

output "distribution_id" {
  description = "ID distribution CloudFront (untuk invalidation)."
  value       = aws_cloudfront_distribution.site.id
}

output "invalidate_command" {
  description = "Perintah untuk membersihkan cache setelah update konten."
  value       = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.site.id} --paths '/*'"
}
