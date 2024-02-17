variable "allowed_principals_readonly" {
  description = "List of principals being granted access to assume role with ReadOnly permissions."
  type        = list(string)
}

variable "allowed_principals_write" {
  description = "List of principals being granted access to assume role with Write permissions."
  type        = list(string)
}

variable "oidc_provider_arn" {
  description = "ARN of OIDC provider."
  type        = string
}

variable "permission_policy_readonly_arn" {
  description = "ARN of an existing ReadOnly permission policy. Required if `permission_policy_readonly_json` is not provided."
  type        = string
  default     = null
}

variable "permission_policy_readonly_json" {
  description = "JSON permission policy with permissions for ReadOnly role. Required if `permission_policy_readonly_arn` is not provided."
  type        = string
  default     = null
}

variable "permission_policy_write_arn" {
  description = "ARN of an existing Write permission policy. Required if `permission_policy_write_json` is not provided."
  type        = string
  default     = null
}

variable "permission_policy_write_json" {
  description = "JSON permission policy with permissions for write role. Required if `permission_policy_write_arn` is not provided."
  type        = string
  default     = null
}

variable "role_name_readonly" {
  description = "Name to give the role with ReadOnly permissions."
  type        = string
}

variable "role_name_write" {
  description = "Name to give the role with Write permissions."
  type        = string
}

variable "terraform_state_policy_arn" {
  description = "ARN of permission policy giving role access to manage Terraform state resources."
  type        = string
}

variable "token_claim_key" {
  description = "Claim key on STS token request to use when comparing requesting principal to allowed values."
  type        = string
  default     = null
}
