# IAM Module - main.tf
# This file will contain IAM role and policy resource definitions
# EBS CSI Driver IAM Role
module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix = var.role_name_prefix

  attach_ebs_csi_policy = var.attach_ebs_csi_policy

  oidc_providers = var.oidc_providers

  tags = {
    Environment = var.environment
    Project = var.project_name
  }
}