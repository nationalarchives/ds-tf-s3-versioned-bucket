# ds-tf-s3-versioned-bucket
This module creates an S3 versioned bucket. It implements our standard tagging and enforces a couple of defaults:

- prevent_destroy: to minimise the risk of terraform offering to destroy a bucket as part of a terraform update
- encryption: AWS managed object encryption
- versioning: versioning enabled with a default but overridable non-current version expiration. The default is 30 days.
- transitions: defaults to disabled, but can be overridden (see below)

## Parameters
*account*: This will be used as a prefix for the bucket created

*environment*, *owner*, *created_by*: For the tags

*name_suffix*: This is the suffix for the bucket name

*noncurrent_version_expiration*: (Default: 30) the number of days after which to expire non-current versions of objects.
 
*transitions*: (Default: none) a list of maps with values transition_days (number of days to transition after) and transition_type (tier to transition to - eg STANDARD_IA, GLACIER etc)

## Outputs
*bucket*: The name of the bucket created
