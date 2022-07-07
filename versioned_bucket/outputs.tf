output "read_policy_arn" {
  value = aws_iam_policy.read_policy.arn
}

output "write_policy_arn" {
  value = aws_iam_policy.write_policy.arn
}

output "bucket" {
  value = aws_s3_bucket.s3_versioned_bucket.bucket
}

output "arn" {
  value = aws_s3_bucket.s3_versioned_bucket.arn
}
