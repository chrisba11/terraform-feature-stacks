resource "aws_api_gateway_rest_api" "default" {
  name = local.api_name
}

resource "aws_api_gateway_deployment" "default" {
  depends_on = [aws_api_gateway_integration.image]

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

resource "aws_api_gateway_resource" "image" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  path_part   = "image"
}

resource "aws_api_gateway_method" "image" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.image.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "image" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.image.id
  http_method = aws_api_gateway_method.image.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.image_lambda.invoke_arn
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
