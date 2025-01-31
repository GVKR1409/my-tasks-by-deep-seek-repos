locals {
  default_tags = {
    "env"        = var.environment
    "app_name"   = var.app_name
    "managed_by" = "Terraform"
  }
}
