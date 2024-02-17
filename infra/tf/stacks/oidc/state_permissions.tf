# policy allowing GitHubActions role to manage TF state resources
data "aws_iam_policy_document" "terraform_state_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.state_backend_name}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${local.state_backend_name}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]

    # the region is hardcoded here because our terraform state dynamo table is in us-west-2
    resources = [
      "arn:aws:dynamodb:us-west-2:${var.aws_account_id}:table/${local.state_backend_name}",
    ]
  }
}

resource "aws_iam_policy" "terraform_state_permissions_policy" {
  name        = "TerraformStatePermissions"
  description = "Allows GithubActionsRole-*** roles to perform Terraform state management actions"
  policy      = data.aws_iam_policy_document.terraform_state_permissions.json
}
