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

variable "github_refs_write" {
  description = "A list of GitHub repository refs that can assume Write role via Actions."
  type        = list(string)
}

variable "repository" {
  description = "The name of the repository where this configuration lives. Pass this in via the CLI in the pipeline."
  type        = string
}
