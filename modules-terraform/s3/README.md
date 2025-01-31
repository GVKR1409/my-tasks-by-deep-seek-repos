Here’s the **Terraform modules code** for the **S3 bucket** with detailed explanations in comments, no hardcoded values, and all values declared as **local variables** or **input variables**. This approach ensures modularity, reusability, and clarity.

---

### **Directory Structure**

```
modules/
  s3/
    main.tf
    variables.tf
    outputs.tf
```

---

### **`modules/s3/main.tf`**

```hcl
# Create an S3 bucket
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name # Bucket name provided as input variable
  acl    = var.acl         # Access Control List (ACL) for the bucket

  # Enable versioning if specified
  versioning {
    enabled = var.versioning_enabled
  }

  # Configure server-side encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm # Encryption algorithm (e.g., AES256, aws:kms)
      }
    }
  }

  # Configure lifecycle rules if enabled
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id                                     = lifecycle_rule.value.id
      enabled                                = lifecycle_rule.value.enabled
      prefix                                 = lifecycle_rule.value.prefix
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days

      # Configure expiration for objects
      expiration {
        days = lifecycle_rule.value.expiration_days
      }

      # Configure transitions to different storage classes
      dynamic "transition" {
        for_each = lifecycle_rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }
    }
  }

  # Add tags to the bucket
  tags = var.tags
}

# Attach a bucket policy if provided
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy
}

# Configure public access block settings
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
```

---

### **`modules/s3/variables.tf`**

```hcl
# Input variable for the bucket name
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

# Input variable for the bucket ACL
variable "acl" {
  description = "The Access Control List (ACL) for the bucket"
  type        = string
  default     = "private"
}

# Input variable to enable/disable versioning
variable "versioning_enabled" {
  description = "Enable or disable versioning for the bucket"
  type        = bool
  default     = false
}

# Input variable for the server-side encryption algorithm
variable "sse_algorithm" {
  description = "The server-side encryption algorithm (e.g., AES256, aws:kms)"
  type        = string
  default     = "AES256"
}

# Input variable for lifecycle rules
variable "lifecycle_rules" {
  description = "List of lifecycle rules to apply to the bucket"
  type = list(object({
    id                                     = string
    enabled                                = bool
    prefix                                 = string
    abort_incomplete_multipart_upload_days = number
    expiration_days                        = number
    transitions = list(object({
      days          = number
      storage_class = string
    }))
  }))
  default = []
}

# Input variable for the bucket policy
variable "bucket_policy" {
  description = "The bucket policy to attach to the bucket"
  type        = string
  default     = ""
}

# Input variables for public access block settings
variable "block_public_acls" {
  description = "Block public ACLs for the bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs for the bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public bucket policies"
  type        = bool
  default     = true
}

# Input variable for tags
variable "tags" {
  description = "A map of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}
```

---

### **`modules/s3/outputs.tf`**

```hcl
# Output the bucket ID
output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

# Output the bucket ARN
output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

# Output the bucket domain name
output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_domain_name
}

# Output the bucket regional domain name
output "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
```

---

### **Using the S3 Module**

Here’s an example of how to use the S3 module in your main Terraform configuration:

```hcl
provider "aws" {
  region = "us-west-2"
}

module "s3_bucket" {
  source = "./modules/s3"

  bucket_name = "example-bucket"
  acl        = "private"

  versioning_enabled = true
  sse_algorithm      = "AES256"

  lifecycle_rules = [
    {
      id                                     = "log-lifecycle-rule"
      enabled                                = true
      prefix                                 = "logs/"
      abort_incomplete_multipart_upload_days = 7
      expiration_days                        = 365
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
    }
  ]

  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::example-bucket/*"
      }
    ]
  })

  tags = {
    Environment = "Production"
    Owner       = "DevOps"
  }
}

output "s3_bucket_id" {
  value = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  value = module.s3_bucket.bucket_arn
}
```

---

### **Key Features**

1. **No Hardcoded Values**:
   - All values are passed as input variables or local variables, making the module reusable and configurable.

2. **Dynamic Lifecycle Rules**:
   - The `lifecycle_rules` variable allows you to define multiple lifecycle rules dynamically.

3. **Public Access Block**:
   - Configures public access settings to ensure the bucket is secure by default.

4. **Outputs**:
   - Outputs useful information like the bucket ID, ARN, and domain names for use in other parts of your Terraform configuration.

---

### **Running Terraform**

1. Initialize the Terraform working directory:
   ```bash
   terraform init
   ```

2. Apply the configuration:
   ```bash
   terraform apply
   ```

This will create an S3 bucket with all the specified configurations. You can reuse this module across multiple projects by simply passing different input variables.
