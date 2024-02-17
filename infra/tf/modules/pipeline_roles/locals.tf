locals {
  # assigns the ARN of the policy, either from an ARN passed in using var.permission_policy_readonly_arn
  # or through the policy resource created from JSON passed in using var.permission_policy_readonly_json
  permission_policy_arn_readonly = var.permission_policy_readonly_arn != null ? var.permission_policy_readonly_arn : aws_iam_policy.permissions_readonly.0.arn
  permission_policy_arn_write    = var.permission_policy_write_arn != null ? var.permission_policy_write_arn : aws_iam_policy.permissions_write.0.arn

  readonly_value_provided = var.permission_policy_readonly_json != null ? true : var.permission_policy_readonly_arn ? true : false
  write_value_provided    = var.permission_policy_write_json != null ? true : var.permission_policy_write_arn ? true : false
}
