##################################
# DownloadImage lambda resources #
##################################

module "download_lambda" {
  source = "../../modules/lambda"

  function_name          = local.download_lambda_name
  description            = "Downloads status cat image and uploads to S3."
  runtime                = "python3.11"
  lambda_handler         = "lambda_function.lambda_handler"
  memory_size            = 128
  timeout                = 180
  permission_policy_json = data.aws_iam_policy_document.download_lambda.json

  lambda_package_bucket_name = local.lambda_package_bucket_name
  lambda_package_object_key  = local.download_lambda_package_key

  api_gateway_execution_arn = "${local.apigw_arn_prefix}/*/${aws_api_gateway_method.download.http_method}/${aws_api_gateway_resource.download.path_part}"

  application_log_level = local.application_log_level_map[var.python_log_level]
  system_log_level      = var.lambda_system_log_level

  environment_variables = {
    IMAGE_BUCKET_NAME   = aws_s3_bucket.image.bucket
    IMAGE_BUCKET_REGION = aws_s3_bucket.image.region
    PYTHON_LOG_LEVEL    = var.python_log_level
  }
}

data "aws_iam_policy_document" "download_lambda" {
  statement {
    sid    = "AllowS3Management"
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = ["${aws_s3_bucket.image.arn}/DownloadImage/*"]
  }
}
