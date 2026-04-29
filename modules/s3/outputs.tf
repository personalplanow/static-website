# Outputs del módulo S3 Static Website

# URL completa del sitio web
output "website_url" {
  description = "URL completa del sitio web con protocolo HTTP"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}