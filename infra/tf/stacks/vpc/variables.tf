variable "aws_account_id" {
  description = "The AWS Account ID."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources will be provisioned."
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "The name of the environment where resources are being deployed."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.0.0/20"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.128.0/20"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "repository" {
  description = "The name of the repository where this configuration lives. Pass this in via the CLI in the pipeline."
  type        = string
}
