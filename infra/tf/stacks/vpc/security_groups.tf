# Destroying a security group will fail if any resources are using it
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#recreating-a-security-group
# Changes to the name or description will require the existing security group to be destroyed

# Please define all security group rules as aws_vpc_security_group_ingress_rule or
# aws_vpc_security_group_egress_rule resources
# This allows more control over the rules, including adding names and descriptions

resource "aws_security_group" "lambda" {
  name        = "${local.app_name_lower}-lambda-sg"
  description = "Contains ingress/egress rules for the Lambdas."
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_egress_rule" "lambda_internet" {
  security_group_id = aws_security_group.lambda.id
  description       = "Allow outbound traffic from Lambdas to the internet."

  ip_protocol = -1
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "${aws_security_group.lambda.name}-internet-egress-rule"
  }
}
