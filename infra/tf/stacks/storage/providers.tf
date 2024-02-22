terraform {
  required_version = ">=1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(local.default_tags, {
      Environment = var.environment
      IaC         = "Terraform"
    })
  }
}
