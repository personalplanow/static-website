# ========================================
# BUCKET S3 PARA SITIO WEB ESTÁTICO
# ========================================

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project
  }
}


resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  # Permite el uso de ACLs públicas
  block_public_acls = false
  
  # Permite políticas de bucket públicas
  block_public_policy = false
  
  # No ignora las ACLs públicas existentes
  ignore_public_acls = false
  
  # Permite que el bucket sea público
  restrict_public_buckets = false
}


# Habilita el hosting de sitio web estático en el bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  # Documento que se sirve por defecto
  index_document {
    suffix = var.index_file_key
  }

  # Documento que se sirve en caso de error 4xx
  error_document {
    key = var.index_file_key
  }
}


resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  # Asegura que la configuración de acceso público se aplique primero
  depends_on = [
    aws_s3_bucket_public_access_block.website,
    aws_s3_bucket_ownership_controls.website
  ]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PublicReadGetObject"
        Effect = "Allow"
        # Permite acceso a cualquier principal
        Principal = "*"
        # Permite solo la operación de lectura
        Action   = "s3:GetObject"
        # Aplica a todos los objetos dentro del bucket
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}



# Sube el archivo index.html al bucket
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website.id
  key    = var.index_file_key
  source = var.index_file_path
  
  content_type = "text/html"
  
  etag = filemd5(var.index_file_path)

  tags = merge(
    {
      Name = "Website Index Page"
    }
  )
}