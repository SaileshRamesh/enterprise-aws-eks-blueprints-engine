variable "name" {
  type        = string
  description = "The name tag and creation token for the EFS file system."
  default     = "eks"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs where the EFS mount targets are created."
}

variable "cluster_primary_security_group_id" {
  type        = string
  description = "Primary EKS cluster security group used by EFS mount targets."
}

variable "storage_class_name" {
  type        = string
  description = "Name of the Kubernetes StorageClass for EFS."
  default     = "efs"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the EFS file system."
  default     = {}
}
