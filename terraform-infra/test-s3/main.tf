provider "aws" {
  region = "us-west-2"
}

module "s3_bucket" {
  source = "../../modules-terraform/s3"

  bucket_name = var.bucket_name
  acl        = "private"

//  versioning_enabled = true
//  sse_algorithm      = "AES256"

//  lifecycle_rule_enabled = true
//  lifecycle_rule_prefix  = "logs/"
//  expiration_days        = 365
//  transition_to_ia_days  = 30
//  transition_to_glacier_days = 90
//  block_public_policy =  false

  bucket_policy = jsonencode(
{
  "Id": "Policy1738299343434",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1738299341850",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*",
      "Principal": {
        "AWS": [
          "arn:aws:iam::471112613084:role/my-role-for-s3-access-to-private-instance"
        ]
      }
    }
  ]
}
)

  tags = {
    Environment = "Production"
    Owner       = "DevOps"
  }
}

variable "bucket_name"{
  default="example-bucket-12132"
}

output "s3_bucket_id" {
  value = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  value = module.s3_bucket.bucket_arn
}
