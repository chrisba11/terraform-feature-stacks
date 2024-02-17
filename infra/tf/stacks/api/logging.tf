# The resources in this module are required to enable Cloudwatch logging for API Gateway
# Only one API Gateway account per region is needed
module "apigw_account" {
  count = local.is_feature_stack == false ? 1 : 0

  source     = "../../modules/apigw_account"
  aws_region = var.aws_region
}
