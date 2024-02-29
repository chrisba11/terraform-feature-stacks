# The resources in this module are required to enable Cloudwatch logging for API Gateway
# Only one API Gateway account per region is needed
module "apigw_account" {
  count = local.is_feature_stack == false ? 1 : 0

  source     = "../../modules/apigw_account"
  aws_region = var.aws_region
}

resource "aws_api_gateway_rest_api" "default" {
  name = local.api_name
}

resource "aws_api_gateway_deployment" "default" {
  depends_on = [
    aws_api_gateway_integration.download,
    aws_api_gateway_integration.reverse,
  ]

  rest_api_id = aws_api_gateway_rest_api.default.id

  triggers = {
    # Trigger deployment when relevant attributes change
    download_resource = "${jsonencode({
      path_part        = aws_api_gateway_resource.download.path_part
      http_method      = aws_api_gateway_method.download.http_method
      authorization    = aws_api_gateway_method.download.authorization
      integration_uri  = aws_api_gateway_integration.download.uri
      integration_type = aws_api_gateway_integration.download.type
    })}"

    reverse_resource = "${jsonencode({
      path_part        = aws_api_gateway_resource.reverse.path_part
      http_method      = aws_api_gateway_method.reverse.http_method
      authorization    = aws_api_gateway_method.reverse.authorization
      integration_uri  = aws_api_gateway_integration.reverse.uri
      integration_type = aws_api_gateway_integration.reverse.type
    })}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "default" {
  stage_name    = local.api_stage_name
  rest_api_id   = aws_api_gateway_rest_api.default.id
  deployment_id = aws_api_gateway_deployment.default.id

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.apigw_access_logs.arn
    format          = local.apigw_access_log_format
  }
}

# CloudWatch logging settings
resource "aws_cloudwatch_log_group" "apigw_access_logs" {
  name              = "/aws/apigateway/${aws_api_gateway_rest_api.default.id}/${local.api_stage_name}"
  retention_in_days = var.cloudwatch_log_retention_days
}

resource "aws_api_gateway_method_settings" "logging" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  stage_name  = aws_api_gateway_stage.default.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = var.gateway_metrics_enabled
    logging_level   = var.gateway_log_level
  }
}


##################################
# DownloadImage lambda resources #
##################################

resource "aws_api_gateway_resource" "download" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  path_part   = "download"
}

resource "aws_api_gateway_method" "download" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.download.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "download" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.download.id
  http_method = aws_api_gateway_method.download.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.download_lambda.invoke_arn
}


##################################
# ReverseImage lambda resources #
##################################

resource "aws_api_gateway_resource" "reverse" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  path_part   = "reverse"
}

resource "aws_api_gateway_method" "reverse" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.reverse.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "reverse" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.reverse.id
  http_method = aws_api_gateway_method.reverse.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.reverse_lambda.invoke_arn
}
