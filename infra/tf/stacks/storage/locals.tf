locals {
  default_tags = {
    Application = "Example"
    Stack       = "storage"
    SCM_Org     = split("/", var.repository)[0]
    SCM_Repo    = split("/", var.repository)[1]
  }

  app_name       = local.default_tags["Application"]
  app_name_lower = lower(local.app_name)

  is_feature_stack = var.feature_tag == null ? false : true

  bucket_prefix = "${replace(lower(local.default_tags["SCM_Org"]), "_", "-")}-${local.app_name_lower}"

  lambda_package_bucket_name = "${local.bucket_prefix}-lambda-packages-${var.environment}"
}
