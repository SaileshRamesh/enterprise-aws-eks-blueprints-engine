variable "cluster_id" {
  type        = string
  description = "EKS cluster ID"
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_ca_certificate_data" {
  type        = string
  description = "Base64 encoded certificate authority data for the cluster"
}

variable "irsa_oidc_provider_arn" {
  type        = string
  description = "ARN of the IRSA OIDC provider"
}

variable "karpenter_module_source" {
  type        = string
  description = "Source for the Karpenter module"
  default     = "terraform-aws-modules/eks/aws//modules/karpenter"
}

variable "karpenter_module_version" {
  type        = string
  description = "Version of the Karpenter module"
  default     = "19.10.0"
}

variable "create_irsa" {
  type        = bool
  description = "Whether to create IRSA for Karpenter"
  default     = false
}

variable "provisioner_ttl_seconds_after_empty" {
  type        = number
  description = "TTL in seconds after empty (scale down nodes after this time without workloads)"
  default     = 60
}

variable "provisioner_ttl_seconds_until_expired" {
  type        = number
  description = "TTL in seconds until node expiration (7 days by default)"
  default     = 604800
}

variable "provisioner_cpu_limit" {
  type        = number
  description = "CPU limit for Karpenter provisioner"
  default     = 100
}

variable "provisioner_instance_families" {
  type        = list(string)
  description = "Instance families to use with Karpenter"
  default     = ["c5", "m5", "r5"]
}

variable "provisioner_excluded_instance_sizes" {
  type        = list(string)
  description = "Instance sizes to exclude from Karpenter"
  default     = ["nano", "micro", "small", "large"]
}

variable "depends_on_modules" {
  type        = list(any)
  description = "Modules that must be created before Karpenter"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to Karpenter resources"
  default     = {}
}
