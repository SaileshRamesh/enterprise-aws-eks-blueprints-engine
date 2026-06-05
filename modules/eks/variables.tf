variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "demo"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster"
  default     = "1.30"
}

variable "enable_irsa" {
  type        = bool
  description = "Enable IAM Roles for Service Accounts"
  default     = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the EKS cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the EKS cluster"
}

variable "eks_managed_node_groups" {
  type        = map(any)
  description = "Managed node group configuration"
  default     = {}
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}


variable "tags" {
  type        = map(string)
  description = "Additional tags applied to EKS resources"
  default     = {}
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Enable or disable public access to the EKS cluster endpoint"
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  type        = bool
  description = "Grant cluster creator admin permissions to the EKS cluster"
  default     = true
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "eks-blueprint"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}