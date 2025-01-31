# S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = var.acl

  versioning {
    enabled = var.versioning_enabled
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  lifecycle_rule {
    id                                     = var.lifecycle_rule_id
    enabled                                = var.lifecycle_rule_enabled
    prefix                                 = var.lifecycle_rule_prefix
    abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days

    expiration {
      days = var.expiration_days
    }

    transition {
      days          = var.transition_to_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.transition_to_glacier_days
      storage_class = "GLACIER"
    }
  }

  tags = var.tags
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy
}

# Public Access Block Configuration
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
