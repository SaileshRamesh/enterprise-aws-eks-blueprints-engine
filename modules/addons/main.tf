module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id = var.eks_cluster_id

  enable_amazon_eks_aws_ebs_csi_driver = var.enable_amazon_eks_aws_ebs_csi_driver
  enable_aws_efs_csi_driver            = var.enable_aws_efs_csi_driver

  aws_efs_csi_driver_helm_config = var.aws_efs_csi_driver_helm_config

  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller

  enable_metrics_server = var.enable_metrics_server
  enable_cert_manager   = var.enable_cert_manager

  enable_karpenter      = var.enable_karpenter
  karpenter_helm_config = var.karpenter_helm_config

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}