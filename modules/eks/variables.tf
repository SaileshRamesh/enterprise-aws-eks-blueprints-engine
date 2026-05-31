variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "demo"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
  default     = "1.25"
}

variable "enable_irsa" {
  type        = bool
  description = "Enable IAM Roles for Service Accounts"
  default     = true
}

variable "map_roles" {
  type        = list(any)
  description = "IAM role mappings to kubernetes RBAC"
  default     = []
}

variable "fargate_profiles" {
  type        = map(any)
  description = "Fargate profile definitions"
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the EKS cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the EKS cluster"
}

variable "managed_node_groups" {
  type        = map(any)
  description = "Managed node group configuration"
  default     = {}
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to EKS resources"
  default     = {}
}
