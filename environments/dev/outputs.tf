#VPC Outputs
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

#EKS Outputs
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

#EBS CSI Driver Outputs
# output "ebs_csi_driver_irsa_role_name" {
#   description = "Name of the IAM role created for the EBS CSI Driver."
#   value       = module.ebs_csi_driver_irsa.iam_role_name
# }

# output "ebs_csi_driver_addon_arn" {
#   description = "ARN of the EBS CSI Driver EKS addon."
#   value       = aws_eks_addon.ebs_csi_driver.addon_arn
# }

# output "karpenter_role_arn" {
#   description = "Karpenter IAM role ARN for node provisioning"
#   value       = module.karpenter.role_arn
# }

# output "karpenter_instance_profile" {
#   description = "Karpenter instance profile name"
#   value       = module.karpenter.instance_profile_name
# }
