resource "aws_s3_bucket" "lambda_package" {
  bucket = local.lambda_package_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_package" {
  bucket = aws_s3_bucket.lambda_package.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "lambda_package" {
  bucket = aws_s3_bucket.lambda_package.id

  versioning_configuration {
    status = "Enabled"
  }
}

# this deletes non-current versions of objects after the specified number of days
resource "aws_s3_bucket_lifecycle_configuration" "lambda_package" {
  bucket = aws_s3_bucket.lambda_package.id

  rule {
    id     = "PurgeOldVersions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.object_version_retention_period
    }

    filter {
      prefix = "" # Apply the rule to all objects
    }
  }
}
