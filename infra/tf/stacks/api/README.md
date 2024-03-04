<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.33.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apigw_account"></a> [apigw\_account](#module\_apigw\_account) | ../../modules/apigw_account | n/a |
| <a name="module_download_lambda"></a> [download\_lambda](#module\_download\_lambda) | ../../modules/lambda | n/a |
| <a name="module_reverse_lambda"></a> [reverse\_lambda](#module\_reverse\_lambda) | ../../modules/lambda | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.download](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration.reverse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.download](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method.reverse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_settings.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_resource.download](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_resource.reverse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource) | resource |
| [aws_api_gateway_rest_api.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_dynamodb_table.status_codes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_iam_policy_document.download_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.reverse_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | The name of the API Gateway resource. | `string` | `"ExampleAPI"` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where resources will be provisioned. | `string` | `"us-west-2"` | no |
| <a name="input_cloudwatch_log_retention_days"></a> [cloudwatch\_log\_retention\_days](#input\_cloudwatch\_log\_retention\_days) | The number of days to retain log events in a Cloudwatch log group. | `number` | `3` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment where resources are being deployed. | `string` | n/a | yes |
| <a name="input_feature_tag"></a> [feature\_tag](#input\_feature\_tag) | The tag to add to the name of Feature Stack resources. Usually the Jira story number, like 'abc123'. | `string` | `null` | no |
| <a name="input_gateway_log_level"></a> [gateway\_log\_level](#input\_gateway\_log\_level) | The log level for API Gateway, which effects the log entries pushed to Amazon CloudWatch Logs. The available levels are 'OFF', 'INFO', and 'ERROR'. | `string` | `"ERROR"` | no |
| <a name="input_gateway_metrics_enabled"></a> [gateway\_metrics\_enabled](#input\_gateway\_metrics\_enabled) | Boolean: Amazon CloudWatch metrics are enabled for the API Gateway. | `bool` | `true` | no |
| <a name="input_lambda_system_log_level"></a> [lambda\_system\_log\_level](#input\_lambda\_system\_log\_level) | The system log level of the Lambda platform. Valid values are 'DEBUG', 'INFO', or 'WARN'. | `string` | `"WARN"` | no |
| <a name="input_object_version_retention_period"></a> [object\_version\_retention\_period](#input\_object\_version\_retention\_period) | The number of days to retain non-current versions of Lambda package zip archives. | `number` | `1` | no |
| <a name="input_python_log_level"></a> [python\_log\_level](#input\_python\_log\_level) | The Python log level inside the Lambda Function. Valid values are 'DEBUG', 'INFO', 'WARNING', 'ERROR', or 'CRITICAL'. | `string` | `"ERROR"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The name of the repository where this configuration lives. Pass this in via the CLI in the pipeline. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->