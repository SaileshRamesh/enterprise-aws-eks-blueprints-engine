output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks_blueprints.eks_cluster_id
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks_blueprints.eks_cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate authority data for the EKS cluster"
  value       = module.eks_blueprints.eks_cluster_certificate_authority_data
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks_blueprints.eks_cluster_name
}

output "cluster_primary_security_group_id" {
  description = "Primary security group ID for the EKS cluster."
  value       = module.eks_blueprints.cluster_primary_security_group_id
}

output "eks_oidc_provider_arn" {
  description = "ARN of the IRSA OIDC provider for the EKS cluster"
  value       = module.eks_blueprints.eks_oidc_provider_arn
}
