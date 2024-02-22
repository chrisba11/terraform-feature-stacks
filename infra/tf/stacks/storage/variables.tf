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

variable "feature_tag" {
  description = "The tag to add to the name of Feature Stack resources. Usually the Jira story number, like 'abc123'."
  type        = string
  default     = null
}

variable "object_version_retention_period" {
  description = "The number of days to retain non-current versions of Lambda package zip archives."
  type        = number
  default     = 1
}

variable "repository" {
  description = "The name of the repository where this configuration lives. Pass this in via the CLI in the pipeline."
  type        = string
}
