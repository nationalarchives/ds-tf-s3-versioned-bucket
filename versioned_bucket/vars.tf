variable "account" {}

# The following two variables are mutually exclusive. Unless there is a compelling reason otherwise, use name_suffix
# When a name_suffix is provided, this module will enforce a naming convention of <account_name>-<name_suffix>
# full_name should only be used if the new naming convention absolutely can't be used (for example, because the bucket
# already exists and would be too much work to migrate)
variable "name_suffix" {}
variable "full_name" {}
variable "noncurrent_version_expiration" {
  default = "30"
}
variable "transitions" {}

variable "tags" {}

variable "bucket_policy" {
  default = []
}
