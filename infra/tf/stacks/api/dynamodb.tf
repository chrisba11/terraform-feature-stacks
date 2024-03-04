resource "aws_dynamodb_table" "status_codes" {
  count = local.is_feature_stack == false ? 1 : 0

  name         = "StatusCodes"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "status_code"

  attribute {
    name = "status_code"
    type = "N"
  }
}
