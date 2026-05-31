output "vpc_id" {
  description = "VPC ID created for the development environment"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block for the development environment"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "Public subnet IDs for the development VPC"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for the development VPC"
  value       = module.vpc.private_subnet_ids
}

output "eks_cluster_id" {
  description = "EKS cluster ID for the development environment"
  value       = module.eks.eks_cluster_id
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint for the development environment"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster Kubernetes version"
  value       = module.eks.eks_cluster_name
}

output "efs_file_system_id" {
  description = "EFS file system ID for persistent storage"
  value       = module.efs.efs_file_system_id
}

output "efs_storage_class" {
  description = "Kubernetes EFS storage class name"
  value       = module.efs.efs_storage_class_name
}

output "karpenter_role_arn" {
  description = "Karpenter IAM role ARN for node provisioning"
  value       = module.karpenter.role_arn
}

output "karpenter_instance_profile" {
  description = "Karpenter instance profile name"
  value       = module.karpenter.instance_profile_name
}
