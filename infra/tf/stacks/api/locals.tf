locals {
  default_tags = {
    Application = "Example"
    Stack       = "api"
    SCM_Org     = split("/", var.repository)[0]
    SCM_Repo    = split("/", var.repository)[1]
  }

  app_name       = local.default_tags["Application"]
  app_name_lower = lower(local.app_name)

  is_feature_stack = var.feature_tag == null ? false : true

  bucket_prefix = "${replace(lower(local.default_tags["SCM_Org"]), "_", "-")}-${local.app_name_lower}"

  api_name         = "${var.api_name}_${local.api_stage_name}"
  api_stage_name   = local.is_feature_stack ? var.feature_tag : var.environment
  apigw_arn_prefix = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${aws_api_gateway_rest_api.default.id}"

  lambda_package_bucket_name = "${local.bucket_prefix}-lambda-packages-${var.environment}"
  lambda_package_key_prefix  = local.is_feature_stack ? "feature/" : ""
  image_bucket_name          = "${local.bucket_prefix}-images-${local.api_stage_name}"

  download_lambda_name        = "DownloadImage_${local.api_stage_name}"
  download_lambda_package_key = "${local.lambda_package_key_prefix}${local.download_lambda_name}.zip"

  reverse_lambda_name        = "ReverseImage_${local.api_stage_name}"
  reverse_lambda_package_key = "${local.lambda_package_key_prefix}${local.reverse_lambda_name}.zip"

  application_log_level_map = {
    DEBUG    = "DEBUG"
    INFO     = "INFO"
    WARNING  = "WARN"
    ERROR    = "ERROR"
    CRITICAL = "FATAL"
  }

  apigw_access_log_format = jsonencode({
    requestId      = "$context.requestId"
    requestTime    = "$context.requestTime"
    httpMethod     = "$context.httpMethod"
    resourcePath   = "$context.resourcePath"
    status         = "$context.status"
    protocol       = "$context.protocol"
    responseLength = "$context.responseLength"
  })
}
