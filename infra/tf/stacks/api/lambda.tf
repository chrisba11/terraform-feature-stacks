module "image_lambda" {
  source = "../../modules/lambda"

  function_name          = local.image_lambda_name
  description            = "Downloads status cat image and uploads to S3."
  runtime                = "python3.11"
  lambda_handler         = "lambda_function.lambda_handler"
  memory_size            = 128
  timeout                = 180
  permission_policy_json = data.aws_iam_policy_document.image_lambda.json

  lambda_package_bucket_name = local.lambda_package_bucket_name
  lambda_package_object_key  = local.image_lambda_package_key

  api_gateway_execution_arn = "${local.apigw_arn_prefix}/*/${aws_api_gateway_method.image.http_method}/${aws_api_gateway_resource.image.path_part}"

  application_log_level = local.application_log_level_map[var.python_log_level]
  system_log_level      = var.lambda_system_log_level

  environment_variables = {
    DESTINATION_BUCKET_NAME   = aws_s3_bucket.image.bucket
    DESTINATION_BUCKET_REGION = aws_s3_bucket.image.region
    PYTHON_LOG_LEVEL          = var.python_log_level
  }
}

data "aws_iam_policy_document" "image_lambda" {
  statement {
    sid    = "AllowS3Management"
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = ["${aws_s3_bucket.image.arn}/*"]
  }
}
