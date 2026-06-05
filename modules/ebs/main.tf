# EBS CSI Driver Addon
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = var.cluster_name
  addon_name               = var.addon_name
  service_account_role_arn = var.service_account_role_arn

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Terraform   = "true"
  }
}