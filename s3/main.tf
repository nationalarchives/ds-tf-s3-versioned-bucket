# ------------------------------------------------------------------------------
# s3 bucket
# This module creates a bucket which has versioning enabled and sets a default (overrideable)
# expiry of 30 days for the non-current object versions. Current versions persist until explicitly
# deleted.
# All buckets should be encrypted, so this is enforced.
# ------------------------------------------------------------------------------

locals {
  bucket_name = try("${var.account}-${var.name_suffix}",var.full_name)
}

resource "aws_s3_bucket" "s3_versioned_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration
    }
    transition {
      days = var.ia_transition
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    name        = local.bucket_name
    environment = var.environment
    owner       = var.owner
    created_by  = var.created_by
  }
}
