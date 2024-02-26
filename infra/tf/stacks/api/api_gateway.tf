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
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.default.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "default" {
  stage_name    = local.api_stage_name
  rest_api_id   = aws_api_gateway_rest_api.default.id
  deployment_id = aws_api_gateway_deployment.default.id
}

# CloudWatch logging settings
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
