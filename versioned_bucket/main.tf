# ------------------------------------------------------------------------------
# s3 bucket
# This module creates a bucket which has versioning enabled and sets a default (overrideable)
# expiry of 30 days for the non-current object versions. Current versions persist until explicitly
# deleted.
# All buckets should be encrypted, so this is enforced.
# ------------------------------------------------------------------------------

locals {
    bucket_name = try("${var.account}-${var.name_suffix}", var.full_name)
}

resource "aws_s3_bucket" "s3_versioned_bucket" {
    bucket = local.bucket_name

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
        dynamic "transition" {
            for_each = var.transitions

            content {
                days          = transition.value.transition_days
                storage_class = transition.value.transition_type
            }
        }
    }

    tags = merge(var.tags, {
        name = local.bucket_name
    })
}

resource "aws_iam_policy" "read_policy" {
  name = "${aws_s3_bucket.s3_versioned_bucket.bucket}-read"
  description = "Read-only access to ${aws_s3_bucket.s3_versioned_bucket.bucket}"
  policy = file("${path.module}/read-policy.json")
}

resource "aws_iam_policy" "write_policy" {
  name = "${aws_s3_bucket.s3_versioned_bucket.bucket}-write"
  description = "Read-Write access to ${aws_s3_bucket.s3_versioned_bucket.bucket}"
  policy = file("${path.module}/write-policy.json")
}
