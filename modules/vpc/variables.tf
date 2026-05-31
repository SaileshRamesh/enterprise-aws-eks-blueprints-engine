variable "name_prefix" {
  type        = string
  description = "Prefix for all VPC resources"
  default     = "eks-blueprint"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones for subnet placement"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"

  validation {
    condition     = length(var.azs) == length(var.public_subnet_cidrs)
    error_message = "The number of public subnet CIDRs must match the number of availability zones."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"

  validation {
    condition     = length(var.azs) == length(var.private_subnet_cidrs)
    error_message = "The number of private subnet CIDRs must match the number of availability zones."
  }
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Additional tags for public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Additional tags for private subnets"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all VPC resources"
  default     = {}
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Whether to create NAT gateways for private subnet outbound access"
  default     = true
}
