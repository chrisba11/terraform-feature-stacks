resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  runtime       = var.runtime
  handler       = var.lambda_handler
  memory_size   = var.memory_size
  timeout       = var.timeout
  role          = aws_iam_role.this.arn

  # S3 object as source for the Lambda function code
  s3_bucket         = var.lambda_package_bucket_name
  s3_key            = var.lambda_package_object_key
  s3_object_version = var.lambda_package_object_version

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [true] : []

    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_group_ids
    }
  }

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [true] : []

    content {
      variables = var.environment_variables
    }
  }

  logging_config {
    application_log_level = var.application_log_level
    log_format            = "JSON"
    log_group             = local.log_group_name
    system_log_level      = var.system_log_level
  }
}

resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.lambda_package_bucket_name}"
}

resource "aws_lambda_permission" "apigw_invoke" {
  count = var.api_gateway_execution_arn != null ? 1 : 0

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_execution_arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.function_name}LambdaRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.cloudwatch_log_group_arn == null ? 1 : 0

  name = "/aws/lambda/${var.function_name}"
}

data "aws_iam_policy_document" "logging" {
  statement {
    sid    = "CloudWatch"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["${local.log_group_arn}:*"]
  }
}

resource "aws_iam_policy" "logging" {
  name        = "${aws_iam_role.this.name}CloudwatchLogsPolicy"
  description = "Cloudwatch logging permissions for ${var.function_name} lambda."
  policy      = data.aws_iam_policy_document.logging.json
}

resource "aws_iam_role_policy_attachment" "logging" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.logging.arn
}

resource "aws_iam_policy" "custom" {
  count = var.use_custom_permission_policy ? 1 : 0

  name        = "${aws_iam_role.this.name}Policy"
  description = "Custom permissions for ${var.function_name} lambda."
  policy      = var.permission_policy_json
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.use_custom_permission_policy ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.custom.0.arn
}

resource "aws_iam_role_policy_attachment" "existing" {
  for_each = toset(var.permission_policy_arn_list)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
