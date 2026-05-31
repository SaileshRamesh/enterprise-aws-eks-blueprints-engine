# Staging Environment - variables.tf
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "staging"
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = "eks-blueprint"
}
