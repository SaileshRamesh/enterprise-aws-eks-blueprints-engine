# IAM Module - variables.tf
# Input variables for IAM module
variable "environment" {
  type        = string
  description = "The environment for which the resources are being created (e.g., dev, staging, prod)."
}

variable "project_name" {
  type        = string
  description = "The name of the project to which the resources belong."
}

variable "oidc_providers" {
  type = map(object({
    provider_arn               = string
    namespace_service_accounts = list(string)
  }))
}

variable "attach_ebs_csi_policy" {
  type        = bool
  description = "Whether to attach the AWS managed policy for EBS CSI Driver to the IAM role."
  default     = true
}

variable "role_name_prefix" {
  type        = string
  description = "Prefix for the IAM role name for the EBS CSI Driver."
}