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
      "apigateway:GET",
      "ec2:DescribeAddresses",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNatGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSecurityGroupRules",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcs",
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListPolicyVersions",
      "iam:ListRolePolicies",
      "lambda:GetFunction",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:GetPolicy",
      "lambda:ListVersionsByFunction",
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketLogging",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketPolicy",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts",
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
      "apigateway:DELETE",
      "apigateway:PATCH",
      "apigateway:POST",
      "apigateway:PUT",
      "ec2:AllocateAddress",
      "ec2:AssociateNatGatewayAddress",
      "ec2:AssociateRouteTable",
      "ec2:AttachInternetGateway",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:CreateInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:CreateRouteTable",
      "ec2:CreateRoute",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateTags",
      "ec2:CreateVpc",
      "ec2:DisassociateRouteTable",
      "ec2:ModifySecurityGroupRules",
      "ec2:ReplaceRoute",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
      "iam:AttachRolePolicy",
      "iam:CreateOpenIDConnectProvider",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateServiceLinkedRole",
      "iam:DetachRolePolicy",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:TagOpenIDConnectProvider",
      "iam:TagPolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateRole",
      "iam:UpdateRoleDescription",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "lambda:AddPermission",
      "lambda:CreateFunction",
      "lambda:InvokeFunction",
      "lambda:RemovePermission",
      "lambda:TagResource",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy",
      "logs:TagLogGroup",
      "s3:AbortMultipartUpload",
      "s3:CreateBucket",
      "s3:PutBucketAcl",
      "s3:PutBucketCORS",
      "s3:PutBucketOwnershipControls",
      "s3:PutBucketPolicy",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutBucketWebsite",
      "s3:PutEncryptionConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectVersionAcl",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "TempS3Permissions"
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = ["arn:aws:s3:::chrisba11-example-lambda-packages-dev/*"]
  }

  # Conditionally add Delete permissions for nonprod environments
  dynamic "statement" {
    for_each = var.environment != "prod" ? [1] : []
    content {
      sid    = "NonprodOnlyWritePermissions"
      effect = "Allow"
      actions = [
        "ec2:DeleteNatGateway",
        "ec2:DeleteRoute",
        "ec2:DeleteRouteTable",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSubnet",
        "ec2:DeleteTags",
        "ec2:DeleteVpc",
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "lambda:DeleteFunction",
        "logs:DeleteLogGroup",
        "s3:DeleteBucket",
        "s3:DeleteBucketPolicy",
        "s3:DeleteBucketWebsite",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
      ]
      resources = ["*"]
    }
  }
}
