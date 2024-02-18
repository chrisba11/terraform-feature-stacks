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
| <a name="module_github_actions_roles"></a> [github\_actions\_roles](#module\_github\_actions\_roles) | ../../modules/pipeline_roles | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.terraform_state_permissions_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_document.permissions_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.permissions_write](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.terraform_state_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS Account ID. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where resources will be provisioned. | `string` | `"us-west-2"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment where resources are being deployed. | `string` | n/a | yes |
| <a name="input_github_refs_write"></a> [github\_refs\_write](#input\_github\_refs\_write) | A list of GitHub repository refs that can assume Write role via Actions. | `list(string)` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | The name of the repository where this configuration lives. Pass this in via the CLI in the pipeline. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->