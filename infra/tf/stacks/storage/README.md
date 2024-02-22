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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.lambda_package](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.lambda_package](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.lambda_package](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.lambda_package](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where resources will be provisioned. | `string` | `"us-west-2"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment where resources are being deployed. | `string` | n/a | yes |
| <a name="input_feature_tag"></a> [feature\_tag](#input\_feature\_tag) | The tag to add to the name of Feature Stack resources. Usually the Jira story number, like 'abc123'. | `string` | `null` | no |
| <a name="input_object_version_retention_period"></a> [object\_version\_retention\_period](#input\_object\_version\_retention\_period) | The number of days to retain non-current versions of Lambda package zip archives. | `number` | `1` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The name of the repository where this configuration lives. Pass this in via the CLI in the pipeline. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
