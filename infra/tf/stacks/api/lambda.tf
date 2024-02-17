module "image_lambda" {
  source = "../../modules/lambda"

  function_name          = local.image_lambda_name
  description            = "Downloads status cat image and uploads to S3."
  runtime                = "python3.11"
  lambda_handler         = "lambda_function.lambda_handler"
  memory_size            = 128
  timeout                = 180
  permission_policy_json = data.aws_iam_policy_document.image_lambda.json

  lambda_package_bucket_name    = local.lambda_package_bucket_name
  lambda_package_object_key     = "${local.lambda_package_key_prefix}${local.image_lambda_name}.zip"
  lambda_package_object_version = aws_s3_object.image_lambda_package.version_id

  api_gateway_execution_arn = "${local.apigw_arn_prefix}/*/${aws_api_gateway_method.image.http_method}/${aws_api_gateway_resource.image.path_part}"

  application_log_level = local.application_log_level[var.python_log_level]
  system_log_level      = var.lambda_system_log_level

  environment_variables = {
    DESTINATION_BUCKET_NAME   = aws_s3_bucket.image.bucket
    DESTINATION_BUCKET_REGION = aws_s3_bucket.image.region
    PYTHON_LOG_LEVEL          = var.python_log_level
  }

  # vpc_config = {
  #   subnet_ids         = data.aws_subnets.private.ids
  #   security_group_ids = [data.aws_security_group.image_lambda.id]
  # }
}

data "aws_iam_policy_document" "image_lambda" {
  # statement {
  #   sid    = "AllowNetworkInterfaceManagement"
  #   effect = "Allow"

  #   actions = [
  #     "ec2:CreateNetworkInterface",
  #     "ec2:DescribeNetworkInterfaces",
  #     "ec2:DeleteNetworkInterface",
  #     "ec2:AssignPrivateIpAddresses",
  #     "ec2:UnassignPrivateIpAddresses"
  #   ]

  #   resources = ["*"]
  # }

  statement {
    sid    = "AllowS3Management"
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = ["${aws_s3_bucket.image.arn}/*"]
  }
}

resource "aws_s3_object" "image_lambda_package" {
  bucket      = aws_s3_bucket.lambda_package.0.bucket
  key         = "${local.lambda_package_key_prefix}/${local.image_lambda_name}.zip"
  source      = "./artifacts/${local.image_lambda_name}.zip"
  source_hash = filemd5("./artifacts/${local.image_lambda_name}.zip")
}
