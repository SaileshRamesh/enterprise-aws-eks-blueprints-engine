data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix           = "eks-blueprint"
  environment           = var.environment
  project_name          = var.project_name
  cidr_block            = "10.1.0.0/16"
  azs                   = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnet_cidrs   = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  private_subnet_cidrs  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
  public_subnet_tags    = { Tier = "public" }
  private_subnet_tags   = { Tier = "private" }
  tags                  = { Purpose = "eks-vpc" }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name        = "${var.environment}-eks"
  cluster_version     = "1.34"
  enable_irsa         = true
  environment         = var.environment
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  map_roles           = []
  fargate_profiles    = {
    staging = {
      fargate_profile_name      = "staging"
      subnet_ids                = module.vpc.private_subnet_ids
      fargate_profile_namespaces = [{ namespace = "staging" }]
    }
  }
  managed_node_groups = {
    general = {
      capacity_type   = "ON_DEMAND"
      node_group_name = "general"
      instance_types  = ["t3a.xlarge"]
      desired_size    = 1
      max_size        = 5
      min_size        = 1
    }
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.eks_cluster_name
}

provider "kubernetes" {
  host                   = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "addons" {
  source = "../../modules/addons"

  eks_cluster_id = module.eks.eks_cluster_id

  enable_amazon_eks_aws_ebs_csi_driver = true
  enable_aws_efs_csi_driver            = true
  aws_efs_csi_driver_helm_config = {
    repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
    version    = "2.4.0"
    namespace  = "kube-system"
  }

  enable_aws_load_balancer_controller = true
  enable_metrics_server              = true
  enable_cert_manager                = true
  enable_karpenter                   = true
  karpenter_helm_config = {
    name       = "karpenter"
    chart      = "karpenter"
    repository = "oci://public.ecr.aws/karpenter"
    version    = "v0.27.0"
    namespace  = "karpenter"
  }

  environment  = var.environment
  project_name = var.project_name
}

module "efs" {
  source = "../../modules/efs"

  name                               = "${var.environment}-efs"
  private_subnet_ids                 = module.vpc.private_subnet_ids
  cluster_primary_security_group_id  = module.eks.cluster_primary_security_group_id
  tags                               = {
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "eks-efs"
  }

  depends_on = [module.addons]
}

module "karpenter" {
  source = "../../modules/karpenter"

  cluster_id                     = module.eks.eks_cluster_id
  cluster_endpoint               = module.eks.eks_cluster_endpoint
  cluster_ca_certificate_data    = module.eks.eks_cluster_certificate_authority_data
  irsa_oidc_provider_arn         = module.eks.eks_oidc_provider_arn
  
  create_irsa                    = false

  provisioner_ttl_seconds_after_empty  = 60
  provisioner_ttl_seconds_until_expired = 604800
  provisioner_cpu_limit                = 100
  provisioner_instance_families        = ["c5", "m5", "r5"]
  provisioner_excluded_instance_sizes  = ["nano", "micro", "small", "large"]

  depends_on_modules = [module.addons]

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "eks-karpenter"
  }
}

# provider "helm" {
#   host                   = module.eks.eks_cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.eks_cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

# Add Karpenter IAM role to aws-auth ConfigMap after module creation to avoid circular dependency
resource "kubernetes_config_map_v1_data" "aws_auth_karpenter" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = base64encode(
      yamlencode(
        concat(
          yamldecode(
            try(
              base64decode(data.kubernetes_config_map_v1.aws_auth.data["mapRoles"]),
              "[]"
            )
          ),
          [{
            rolearn  = module.karpenter.role_arn
            username = "system:node:{{EC2PrivateDNSName}}"
            groups = [
              "system:bootstrappers",
              "system:nodes",
            ]
          }]
        )
      )
    )
  }

  force = true

  depends_on = [module.karpenter]
}

data "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  depends_on = [module.addons]
}

# Generate random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
  # Exclude characters that might cause issues in connection strings
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# RDS Module
module "rds" {
  source = "../../modules/rds"

  environment             = var.environment
  project                 = var.project_name
  subnet_ids              = module.vpc.database_subnet_ids
  security_group_id       = module.security_groups.rds_sg_id
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  engine_version          = var.db_engine_version
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = random_password.db_password.result
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention
  skip_final_snapshot     = var.db_skip_final_snapshot

  tags                               = {
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "eks-rds"
  }
}