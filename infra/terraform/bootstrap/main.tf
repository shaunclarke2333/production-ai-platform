# S3 bucket for global backend state management.
resource "aws_s3_bucket" "backend_state_bucket" {
  bucket = var.s3_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.bucket_tags["Name"]
    Environment = var.bucket_tags["Environment"]
    Project     = var.bucket_tags["Project"]
  }
}

# Turnin on versioning for the s3 bucket
resource "aws_s3_bucket_versioning" "backend_state_bucket_versioning" {
  bucket = aws_s3_bucket.backend_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Turning on server-side encryption for the s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "backend_state_bucket_encryption" {
  bucket = aws_s3_bucket.backend_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Blocking publiv access to teh S3 bucket.
resource "aws_s3_bucket_public_access_block" "back_end_state_bucket_public_access_block" {
  bucket = aws_s3_bucket.backend_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
