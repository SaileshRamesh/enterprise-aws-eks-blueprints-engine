output "role_arn" {
  description = "ARN of the Karpenter IAM role"
  value       = module.karpenter.role_arn
}

output "instance_profile_name" {
  description = "Name of the Karpenter instance profile"
  value       = module.karpenter.instance_profile_name
}

output "role_name" {
  description = "Name of the Karpenter IAM role"
  value       = module.karpenter.role_name
}

output "karpenter_provisioner_name" {
  description = "Name of the created Karpenter provisioner"
  value       = kubectl_manifest.karpenter_provisioner.name
}

output "karpenter_template_name" {
  description = "Name of the created Karpenter AWSNodeTemplate"
  value       = kubectl_manifest.karpenter_template.name
}
