variable "environment" {
  type        = string
  description = "Environment tag value."
}

variable "project_name" {
  type        = string
  description = "Project name tag value."
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster to which the EBS CSI Driver addon will be attached."
}

variable "addon_name" {
  type        = string
  description = "Name of the EBS CSI Driver addon."
  default     = "aws-ebs-csi-driver"
}

variable "service_account_role_arn" {
  type        = string
  description = "ARN of the IAM role to be used by the EBS CSI Driver addon."
}