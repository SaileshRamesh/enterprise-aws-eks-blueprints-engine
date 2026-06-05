data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix          = "eks-blueprint"
  environment          = var.environment
  project_name         = var.project_name
  cidr_block           = "10.0.0.0/16"
  azs                  = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnet_tags   = { Tier = "public" }
  private_subnet_tags  = { Tier = "private" }
  tags                 = { Purpose = "eks-vpc" }
}

module "eks" {
  source = "../../modules/eks"

  environment                    = var.environment
  cluster_name                   = "${var.environment}-eks-cluster"
  cluster_version                = "1.30"
  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  private_subnet_ids             = module.vpc.private_subnet_ids
  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.medium"]
      min_size       = 2
      max_size       = 3
      desired_size   = 2
      subnet_ids     = module.vpc.private_subnet_ids
    }
  }
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true
}

module "ebs_csi_driver_irsa" {
  source = "../../modules/iam"
  
  role_name_prefix = "${var.environment}-ebs-csi-driver"
  attach_ebs_csi_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
  environment = var.environment
  project_name = var.project_name
}

module "ebs_csi_driver" {
  source = "../../modules/ebs"

  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
  environment              = var.environment
  project_name            = var.project_name
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

# Secrets Manager Module
module "secrets" {
  source = "../../modules/secrets"

  environment = var.environment
  project     = var.project_name
  db_username = var.db_username
  db_password = random_password.db_password.result
  db_host     = module.rds.db_address
  db_port     = module.rds.db_port
  db_name     = var.db_name

  tags                               = {
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "eks-rds"
  }
}
