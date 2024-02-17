locals {
  log_group_arn  = var.cloudwatch_log_group_arn != null ? var.cloudwatch_log_group_arn : aws_cloudwatch_log_group.this.0.arn
  log_group_name = var.cloudwatch_log_group_arn != null ? split(":", var.cloudwatch_log_group_arn)[5] : aws_cloudwatch_log_group.this.0.name
}
