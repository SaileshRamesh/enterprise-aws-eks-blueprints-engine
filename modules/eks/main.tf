module "eks_blueprints" {
  source = "git::https://github.com/aws-ia/terraform-aws-eks-blueprints.git?ref=v4.25.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  enable_irsa     = var.enable_irsa

  map_roles = var.map_roles

  fargate_profiles = var.fargate_profiles

  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids

  managed_node_groups = var.managed_node_groups

  tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}
