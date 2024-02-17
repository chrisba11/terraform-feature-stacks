##########################################
# Role for use with ReadOnly permissions #
##########################################

# Role used by the CI/CD pipeline when Write permissions are NOT needed
resource "aws_iam_role" "pipeline_role_readonly" {
  name               = var.role_name_readonly
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role_readonly.0.json
}

# Policy statement allowing requesting principal to assume ReadOnly role
data "aws_iam_policy_document" "pipeline_assume_role_readonly" {
  count = var.permission_policy_readonly_json != null ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = var.token_claim_key
      values   = var.allowed_principals_readonly
    }
  }
}

# Policy resource to use var.permission_policy_readonly policy document data
resource "aws_iam_policy" "permissions_readonly" {
  count = var.permission_policy_readonly_json != null ? 1 : 0

  name        = "${var.role_name_readonly}Policy"
  description = "Allows ${var.role_name_readonly} to perform ReadOnly actions in this account."
  policy      = var.permission_policy_readonly_json
}

# Policy attachment for permissions_readonly policy to the pipeline ReadOnly role
resource "aws_iam_role_policy_attachment" "permissions_readonly" {
  count = local.readonly_value_provided ? 1 : 0

  role       = aws_iam_role.pipeline_role_readonly.name
  policy_arn = local.permission_policy_arn_readonly
}

# Policy attachment for TerraformStatePermissions policy to the pipeline ReadOnly role
resource "aws_iam_role_policy_attachment" "terraform_state_permissions_readonly" {
  role       = aws_iam_role.pipeline_role_readonly.name
  policy_arn = var.terraform_state_policy_arn
}


#######################################
# Role for use with Write permissions #
#######################################

# Role used by the CI/CD pipeline when Write permissions ARE needed
resource "aws_iam_role" "pipeline_role_write" {
  name               = var.role_name_write
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role_write.0.json
}

# Policy statement allowing pipeline to assume Write role
data "aws_iam_policy_document" "pipeline_assume_role_write" {
  count = var.permission_policy_write_json != null ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = var.token_claim_key
      values   = var.allowed_principals_write
    }
  }
}

# Policy resource to use var.permission_policy_write policy document data
resource "aws_iam_policy" "permissions_write" {
  count = var.permission_policy_write_json != null ? 1 : 0

  name        = "${var.role_name_write}Policy"
  description = "Allows ${var.role_name_write} to perform Write actions in this account."
  policy      = var.permission_policy_write_json
}

# Policy attachment for permissions_readonly policy to the pipeline Write role
# This allows us to avoid repeating ReadOnly permissions in the Write permissions set
resource "aws_iam_role_policy_attachment" "permissions_readonly_write_role" {
  count = local.readonly_value_provided ? 1 : 0

  role       = aws_iam_role.pipeline_role_write.name
  policy_arn = local.permission_policy_arn_readonly
}

# Policy attachment for permissions_write policy to the pipeline Write role
resource "aws_iam_role_policy_attachment" "permissions_write" {
  count = local.write_value_provided ? 1 : 0

  role       = aws_iam_role.pipeline_role_write.name
  policy_arn = local.permission_policy_arn_write
}

# Policy attachment for TerraformStatePermissions policy to the pipeline Write role
resource "aws_iam_role_policy_attachment" "terraform_state_permissions_write" {
  role       = aws_iam_role.pipeline_role_write.name
  policy_arn = var.terraform_state_policy_arn
}
