locals {
  default_tags = {
    Application = "Example"
    Stack       = "api"
    SCM_Org     = split("/", var.repository)[0]
    SCM_Repo    = split("/", var.repository)[1]
  }

  application_log_level_map = {
    DEBUG    = "DEBUG"
    INFO     = "INFO"
    WARNING  = "WARN"
    ERROR    = "ERROR"
    CRITICAL = "FATAL"
  }

  app_name       = local.default_tags["Application"]
  app_name_lower = lower(local.app_name)

  is_feature_stack = var.feature_tag == null ? false : true

  bucket_prefix = "${replace(lower(local.default_tags["SCM_Org"]), "_", "-")}-${local.app_name_lower}"

  api_name         = local.is_feature_stack ? "${var.api_name}_${var.feature_tag}" : var.api_name
  api_stage_name   = local.is_feature_stack ? var.feature_tag : var.environment
  apigw_arn_prefix = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.default.id}"

  lambda_package_bucket_name = "${local.bucket_prefix}-lambda-packages-${var.environment}"
  lambda_package_key_prefix  = local.is_feature_stack ? "feature/" : ""

  image_lambda_name = local.is_feature_stack ? "ImageDownload_${var.feature_tag}" : "ImageDownload"
  image_bucket_name = local.is_feature_stack ? "${local.bucket_prefix}-images-${var.feature_tag}" : "${local.bucket_prefix}-images"
}
