# Identity Provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github_oidc" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    # The thumbprint below is from github's cert chain (see blog post below for details)
    # https://github.blog/changelog/2022-01-13-github-actions-update-on-oidc-based-deployments-to-aws/
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    # Additional thumbprints taken from this GH issue
    # https://github.com/aws-actions/configure-aws-credentials/issues/357#issuecomment-1613427884
    "f879abce0008e4eb126e0097e46620f5aaae26ad",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

module "github_actions_roles" {
  source = "../../modules/pipeline_roles"

  oidc_provider_arn               = aws_iam_openid_connect_provider.github_oidc.arn
  permission_policy_readonly_json = data.aws_iam_policy_document.permissions_readonly.json
  permission_policy_write_json    = data.aws_iam_policy_document.permissions_write.json
  role_name_readonly              = local.github_role_readonly
  role_name_write                 = local.github_role_write
  terraform_state_policy_arn      = aws_iam_policy.terraform_state_permissions_policy.arn

  token_claim_key             = "token.actions.githubusercontent.com:sub"
  allowed_principals_readonly = ["repo:chrisba11/terraform-feature-stacks:*"]
  allowed_principals_write    = var.github_refs_write
}

# policy allowing GitHub Actions role to perform ReadOnly actions on the specified resources
data "aws_iam_policy_document" "permissions_readonly" {
  statement {
    sid    = "GeneralReadOnlyPermissions"
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = ["*"]
  }
}

# Policy allowing GitHub Actions role to perform Write actions on the specified resources
# No need to repeat ReadOnly actions listed in the ReadOnly policy above
# Both ReadOnly and Write policy documents will be added to the Write role
data "aws_iam_policy_document" "permissions_write" {
  statement {
    sid    = "GeneralWritePermissions"
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    resources = ["*"]
  }
}
