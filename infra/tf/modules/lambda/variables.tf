variable "api_gateway_execution_arn" {
  description = "ARN of the API Gateway if used to invoke the lambda."
  type        = string
  default     = null
}

variable "application_log_level" {
  description = "The application log level inside the Lambda Function. Valid values are 'TRACE', 'DEBUG', 'INFO', 'WARN', 'ERROR', or 'FATAL'."
  type        = string
  default     = "ERROR"

  validation {
    condition     = contains(["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"], var.application_log_level)
    error_message = "The application log level must be one of 'TRACE', 'DEBUG', 'INFO', 'WARN', 'ERROR', or 'FATAL'."
  }
}

variable "cloudwatch_log_group_arn" {
  description = "ARN of an existing Cloudwatch log group where logs should be sent."
  type        = string
  default     = null
}

variable "cloudwatch_log_retention_days" {
  description = "The number of days to retain log events in the Cloudwatch log group."
  type        = number
  default     = 3
}

variable "description" {
  description = "Description for the Lambda function."
  type        = string
}

variable "environment_variables" {
  description = "Map of environment variables for the Lambda function."
  type        = map(string)
  default     = {}
}

variable "function_name" {
  description = "Name to give the Lambda function."
  type        = string
}

variable "lambda_handler" {
  description = "Name the Lambda's handler function."
  type        = string
}

variable "memory_size" {
  description = "How much memory does the Lambda need?"
  type        = number
}

variable "lambda_package_bucket_name" {
  description = "Name of the S3 Bucket where the zip archive of the Lambda code lives."
  type        = string
}

variable "lambda_package_object_key" {
  description = "Object key in the S3 Bucket for the zip archive of the Lambda code."
  type        = string
}

variable "lambda_package_object_version" {
  description = "Version of the object in the S3 Bucket. Changes trigger re-deploy of lambda."
  type        = string
}

variable "permission_policy_arn_list" {
  description = "List of ARNs for existing permission policies to attach to the Lambda. Required if `permission_policy_json` is not provided."
  type        = list(string)
  default     = []
}

variable "permission_policy_json" {
  description = "JSON permission policy for Lambda. Required if `permission_policy_arn` is not provided."
  type        = string
  default     = null
}

variable "runtime" {
  description = "Lambda function runtime."
  type        = string
}

variable "system_log_level" {
  description = "The system log level of the Lambda platform. Valid values are 'DEBUG', 'INFO', or 'WARN'."
  type        = string
  default     = "WARN"

  validation {
    condition     = contains(["DEBUG", "INFO", "WARN"], var.system_log_level)
    error_message = "The system log level must be one of 'DEBUG', 'INFO', or 'WARN'."
  }
}

variable "timeout" {
  description = "Timeout in seconds."
  type        = number
  default     = 600
}

variable "use_custom_permission_policy" {
  description = "Boolean: A custom permission policy will be provided."
  type        = bool
  default     = true
}

variable "vpc_config" {
  description = "VPC configuration for the Lambda function. Omit if not using VPC."
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}
