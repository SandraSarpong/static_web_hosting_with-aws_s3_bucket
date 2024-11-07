# Create a bucket
resource "aws_s3_bucket" "bucket_name" {
  bucket = var.bucket
}

# Add ownership to bucket
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.bucket_name.id
  rule {
    object_ownership = var.object_ownership
  }
}

# Public access  block disabled

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.bucket_name.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Versioning not allowed
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.bucket_name.id
  versioning_configuration {
    status = "Disabled"
  }
}

# Encrypting bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket_name.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

# Add html file to bucket
resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.bucket_name.id
  key          = "index.html"
  source       = "index.html"
  acl          = "bucket-owner-read"
  content_type = "text/html"
  etag         = filemd5("index.html")
}

# Add a bucket policy granting public read access
resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.bucket_name.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.bucket_name.arn}/*"
      }
    ]
  })
}
