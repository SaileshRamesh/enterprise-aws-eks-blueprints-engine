# Terraform Variables File Template
# Copy this file and rename to terraform.tfvars
# Update all values according to your environment

################################################################################
# Core Configuration
################################################################################

# AWS region for resource deployment
aws_region = \"us-east-1\"

# Environment name (dev, staging, prod)
# IMPORTANT: Must match the environment directory name
environment = \"dev\"

# Project name used for resource naming and tagging
# Format: lowercase alphanumerics and hyphens only, 3-32 characters
project_name = \"eks-blueprint\"

################################################################################
# VPC Configuration (dev-specific values shown, adjust for prod)
################################################################################

# VPC CIDR block - Change for each environment to avoid overlap
# dev:     10.0.0.0/16
# staging: 10.1.0.0/16
# prod:    10.2.0.0/16
vpc_cidr = \"10.0.0.0/16\"

# Availability zones for multi-AZ deployment (min 2, recommend 3)
# These are automatically selected from the AWS region
azs = [\"us-east-1a\", \"us-east-1b\", \"us-east-1c\"]

# Public subnet CIDR blocks (one per AZ)
public_subnet_cidrs = [
  \"10.0.1.0/24\",
  \"10.0.2.0/24\",
  \"10.0.3.0/24\"
]

# Private subnet CIDR blocks (one per AZ)
private_subnet_cidrs = [
  \"10.0.101.0/24\",
  \"10.0.102.0/24\",
  \"10.0.103.0/24\"
]

################################################################################
# EKS Configuration
################################################################################

# Kubernetes version (must be >= 1.20)
# Recommended: Use LTS versions (e.g., 1.25, 1.27)
# Update carefully in production - always test in dev first
cluster_version = \"1.25\"

# Enable IAM Roles for Service Accounts (IRSA)
# Required for: EBS/EFS CSI drivers, ALB controller, Karpenter
enable_irsa = true

################################################################################
# Node Group Configuration
################################################################################

# Managed node group settings
# Adjust size parameters based on workload requirements
managed_node_groups = {
  general = {
    # Instance type(s) for general workloads
    instance_types = [\"t3a.xlarge\"]
    
    # Desired number of nodes (start small, scale as needed)
    desired_size = 1
    
    # Minimum nodes (keep >= 1 for availability)
    min_size = 1
    
    # Maximum nodes (capacity limit)
    max_size = 5
    
    # Capacity type (ON_DEMAND or SPOT)
    # Use SPOT for dev/test to save costs
    # Use ON_DEMAND for production
    capacity_type = \"ON_DEMAND\"
    
    # Labels for pod scheduling
    labels = {
      Environment = \"dev\"
      Workload    = \"general\"
    }
  }
}

################################################################################
# Fargate Configuration (optional)
################################################################################

# Fargate profiles for serverless workloads
# Useful for staging/logging, exclude critical workloads
fargate_profiles = {
  staging = {
    fargate_profile_name = \"staging\"
    fargate_profile_namespaces = [
      { namespace = \"staging\" }
    ]
  }
}

################################################################################
# Tags Configuration
################################################################################

# Common tags applied to all resources
# Helps with cost tracking, compliance, and resource management
tags = {
  CreatedBy   = \"Terraform\"
  Environment = \"dev\"
  CostCenter  = \"engineering\"
  BackupPolicy = \"daily\"
}

################################################################################
# Karpenter Configuration (for auto-scaling)
################################################################################

# Provisioner TTL after nodes are empty (in seconds)
# 60 = scale down after 1 minute with no workloads
karpenter_ttl_seconds_after_empty = 60

# Provisioner TTL until node expiration (in seconds)
# 604800 = 7 days - nodes are cycled every week
karpenter_ttl_seconds_until_expired = 604800

# CPU limit for Karpenter provisioner
karpenter_cpu_limit = 100

# Instance families for Karpenter to provision
# Popular choices: c5, m5, r5 (general purpose, burstable)
# For cost: include t3 variants
karpenter_instance_families = [\"c5\", \"m5\", \"r5\"]

# Instance sizes to EXCLUDE
# Avoid small instances that lack resources for pod scheduling
karpenter_excluded_instance_sizes = [\"nano\", \"micro\", \"small\", \"large\"]

################################################################################
# Add-ons Configuration
################################################################################

# Enable AWS EBS CSI Driver for block storage
enable_ebs_csi_driver = true

# Enable AWS EFS CSI Driver for NFS storage
enable_efs_csi_driver = true

# EFS CSI Driver Helm chart configuration
efs_csi_driver_helm_config = {
  repository = \"https://kubernetes-sigs.github.io/aws-efs-csi-driver/\"
  version    = \"2.4.0\"
  namespace  = \"kube-system\"
}

# Enable AWS Load Balancer Controller (required for ALB/NLB)
enable_load_balancer_controller = true

# Enable Metrics Server (required for HPA)
enable_metrics_server = true

# Enable Cert Manager (required for TLS certificates)
enable_cert_manager = true

# Enable Karpenter for auto-scaling
enable_karpenter = true

# Karpenter Helm chart configuration
karpenter_helm_config = {
  name       = \"karpenter\"
  chart      = \"karpenter\"
  repository = \"oci://public.ecr.aws/karpenter\"
  version    = \"v0.27.0\"
  namespace  = \"karpenter\"
}

################################################################################
# State Management (when using S3 backend)
################################################################################

# NOTE: S3 bucket names must be globally unique across AWS
# Backend configuration is in environments/{env}/terraform.tf
# State bucket naming convention:
# - dev:     eks-blueprint-terraform-state-dev
# - staging: eks-blueprint-terraform-state-staging
# - prod:    eks-blueprint-terraform-state-prod

# Ensure these S3 buckets exist before running terraform init
# Create with: aws s3api create-bucket --bucket <bucket-name> --region us-east-1

################################################################################
# Notes for Production Deployment
################################################################################

# 1. Before deploying to production:
#    - Test all changes in dev environment first
#    - Use a separate AWS account for prod
#    - Enable CloudTrail for audit logging
#    - Configure backup strategy for EFS
#
# 2. Production recommendations:
#    - Set cluster_version to a stable/LTS version
#    - Use ON_DEMAND capacity for critical workloads
#    - Enable cluster autoscaling
#    - Use private subnets only (no public IPs)
#    - Implement network policies for segmentation
#    - Enable RBAC and pod security policies
#    - Monitor cluster health with CloudWatch
#
# 3. Cost optimization:
#    - Use Karpenter for bin-packing
#    - Mix ON_DEMAND + SPOT instances
#    - Right-size node types for your workloads
#    - Use Fargate for unpredictable workloads
#    - Implement resource requests/limits
#
# 4. Security:
#    - Use IRSA for pod authentication
#    - Implement network policies
#    - Enable pod security policies
#    - Scan container images for vulnerabilities
#    - Rotate credentials regularly
