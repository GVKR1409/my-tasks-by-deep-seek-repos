variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "acl" {
  description = "The ACL for the S3 bucket"
  type        = string
  default     = "private"
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use (e.g., AES256, aws:kms)"
  type        = string
  default     = "AES256"
}

variable "lifecycle_rule_id" {
  description = "Unique ID for the lifecycle rule"
  type        = string
  default     = "default-lifecycle-rule"
}

variable "lifecycle_rule_enabled" {
  description = "Enable or disable the lifecycle rule"
  type        = bool
  default     = false
}

variable "lifecycle_rule_prefix" {
  description = "Prefix filter for the lifecycle rule"
  type        = string
  default     = ""
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Number of days to abort incomplete multipart uploads"
  type        = number
  default     = 7
}

variable "expiration_days" {
  description = "Number of days until objects expire"
  type        = number
  default     = 90
}

variable "transition_to_ia_days" {
  description = "Number of days until objects transition to STANDARD_IA"
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Number of days until objects transition to GLACIER"
  type        = number
  default     = 60
}

variable "bucket_policy" {
  description = "The bucket policy to apply to the S3 bucket"
  type        = string
  default     = ""
}

variable "block_public_acls" {
  description = "Block public ACLs for the S3 bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies for the S3 bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs for the S3 bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies for the S3 bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}
