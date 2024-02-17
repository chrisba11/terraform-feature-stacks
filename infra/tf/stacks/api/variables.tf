variable "api_name" {
  description = "The name of the API Gateway resource."
  type        = string
  default     = "ExampleAPI"
}

variable "python_log_level" {
  description = "The Python log level inside the Lambda Function. Valid values are 'DEBUG', 'INFO', 'WARNING', 'ERROR', or 'CRITICAL'."
  type        = string
  default     = "ERROR"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"], var.python_log_level)
    error_message = "The Python log level must be one of 'DEBUG', 'INFO', 'WARNING', 'ERROR', or 'CRITICAL'."
  }
}

variable "aws_account_id" {
  description = "The AWS Account ID."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources will be provisioned."
  type        = string
  default     = "us-west-2"
}

variable "cloudwatch_log_retention_days" {
  description = "The number of days to retain log events in a Cloudwatch log group."
  type        = number
  default     = 3
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

variable "gateway_log_level" {
  description = "The log level for API Gateway, which effects the log entries pushed to Amazon CloudWatch Logs. The available levels are 'OFF', 'INFO', and 'ERROR'."
  type        = string
  default     = "ERROR"

  validation {
    condition     = contains(["OFF", "INFO", "ERROR"], var.gateway_log_level)
    error_message = "The gateway log level must be one of 'OFF', 'INFO', or 'ERROR'."
  }
}

variable "gateway_metrics_enabled" {
  description = "Boolean: Amazon CloudWatch metrics are enabled for the API Gateway."
  type        = bool
  default     = true
}

variable "lambda_system_log_level" {
  description = "The system log level of the Lambda platform. Valid values are 'DEBUG', 'INFO', or 'WARN'."
  type        = string
  default     = "WARN"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARN"], var.lambda_system_log_level)
    error_message = "The system log level must be one of 'DEBUG', 'INFO', or 'WARN'."
  }
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
