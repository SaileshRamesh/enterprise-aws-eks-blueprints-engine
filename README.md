# Terraform EKS Blueprint

A **production-grade** Terraform configuration for deploying and managing highly available, secure, and scalable Amazon EKS (Elastic Kubernetes Service) clusters.

## Features

- ✅ Multi-environment support (dev, staging, prod)
- ✅ Modular architecture for reusability
- ✅ VPC with public/private subnets across multiple AZs
- ✅ EKS cluster with managed node groups and Fargate profiles
- ✅ Auto-scaling with Karpenter for cost optimization
- ✅ EFS for persistent storage with Kubernetes StorageClass
- ✅ Essential add-ons: AWS Load Balancer Controller, Cert Manager, Metrics Server
- ✅ Remote state management with S3 backend and DynamoDB locking
- ✅ Comprehensive tagging for resource management
- ✅ Input validation and error handling

## Project Structure

```
.
├── environments/
│   ├── dev/                    # Development environment
│   │   ├── terraform.tf        # Provider and backend config
│   │   ├── main.tf             # Module instantiation
│   │   ├── variables.tf        # Environment variables
│   │   └── outputs.tf          # Environment outputs
│   ├── prod/                   # Production environment
│   │   ├── terraform.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── staging/                # Staging environment
├── modules/
│   ├── vpc/                    # VPC and networking
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── eks/                    # EKS cluster wrapper
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   ├── addons/                 # EKS add-ons (Helm charts)
│   ├── efs/                    # Elastic File System
│   ├── karpenter/              # Karpenter auto-scaler
│   ├── security/               # Security groups and policies
│   ├── iam/                    # IAM roles and permissions
│   └── monitoring/             # CloudWatch and observability
├── terraform.tf                # Root provider configuration
├── variables.tf                # Root variables
├── outputs.tf                  # Root outputs
├── locals.tf                   # Root local values
├── example.tfvars              # Variable template
├── .gitignore                  # Git ignore patterns
├── README.md                   # This file
└── docs/                       # Additional documentation

```

## Prerequisites

### Required Tools

- **Terraform** >= 1.0
- **AWS CLI** v2+ with configured credentials
- **kubectl** >= 1.25
- **helm** >= 3.0 (for add-on management)

### AWS Permissions

Your AWS IAM user/role needs permissions for:
- VPC, subnets, route tables, NAT gateways
- EKS cluster, node groups, Fargate profiles
- IAM roles and policies (IRSA)
- EFS file systems and mount targets
- Security groups
- CloudWatch logs
- S3 (for state), DynamoDB (for state locking)

### AWS Account Setup

1. **Create S3 bucket for Terraform state** (if using remote state):
   ```bash
   aws s3api create-bucket \
     --bucket eks-blueprint-terraform-state-dev \
     --region us-east-1
   
   aws s3api put-bucket-versioning \
     --bucket eks-blueprint-terraform-state-dev \
     --versioning-configuration Status=Enabled
   
   aws s3api put-bucket-encryption \
     --bucket eks-blueprint-terraform-state-dev \
     --server-side-encryption-configuration '{
       "Rules": [{
         "ApplyServerSideEncryptionByDefault": {
           "SSEAlgorithm": "AES256"
         }
       }]
     }'
   ```

2. **Create DynamoDB table for state locking** (optional):
   ```bash
   aws dynamodb create-table \
     --table-name terraform-locks \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST
   ```

## Quick Start

### 1. Clone and Initialize

```bash
git clone <repository-url>
cd terraform-eks-blueprint
cd environments/dev
terraform init
```

### 2. Configure Variables

Copy and customize the example variables file:

```bash
cp ../../example.tfvars terraform.tfvars
# Edit terraform.tfvars with your values
```

### 3. Plan and Review

```bash
terraform plan -out=tfplan
```

### 4. Apply Configuration

```bash
terraform apply tfplan
```

### 5. Configure kubectl

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name dev-eks
  
kubectl get nodes
```

## Usage Details

### Environment Variables (in terraform.tfvars)

```hcl
aws_region   = "us-east-1"
environment  = "dev"          # dev, staging, or prod
project_name = "eks-blueprint"
```

### Deploy to Production

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

### Destroy Resources

```bash
terraform destroy
```

**⚠️ Warning**: This will delete all resources including the EKS cluster and any data in EFS.

## Module Details

### VPC Module
- Creates a VPC with configurable CIDR block
- Public subnets with Internet Gateway
- Private subnets with NAT Gateway for outbound internet
- Automatic subnet tagging for EKS discovery
- Support for 2-3 availability zones

### EKS Module
- Wraps AWS EKS Blueprints module (v4.25.0)
- Configurable cluster version (default: 1.25)
- Managed node groups with auto-scaling
- Fargate profiles for serverless workloads
- IRSA (IAM Roles for Service Accounts) enabled
- Security group auto-provisioning

### EFS Module
- Creates EFS with encryption enabled
- Mount targets in all private subnets
- Kubernetes StorageClass for dynamic provisioning
- Depends on add-ons module (CSI driver installed)

### Karpenter Module
- Provisions EC2 instances on-demand
- Automatically scales nodes based on pod requirements
- Configurable instance families and sizes
- Built-in node consolidation for cost optimization
- Integrates with EKS via RBAC

### Add-ons Module
- AWS EBS CSI Driver
- AWS EFS CSI Driver
- AWS Load Balancer Controller
- Metrics Server
- Cert Manager
- Karpenter Helm chart

## Production Best Practices

### 1. State Management

- ✅ Use S3 backend with encryption
- ✅ Enable state locking with DynamoDB
- ✅ Enable versioning on S3 bucket
- ✅ Restrict S3 bucket access with IAM policies
- ✅ Never commit state files to version control

### 2. Security

- ✅ Use IRSA for pod authentication
- ✅ Enable RBAC for EKS
- ✅ Restrict security group ingress rules
- ✅ Enable CloudWatch container insights
- ✅ Use private subnets for nodes
- ✅ Enable EBS volume encryption

### 3. High Availability

- ✅ Deploy across multiple AZs (3 recommended)
- ✅ Use managed node groups for auto-healing
- ✅ Configure pod disruption budgets
- ✅ Use Karpenter for efficient scaling
- ✅ Monitor cluster health with CloudWatch

### 4. Cost Optimization

- ✅ Use Karpenter for bin-packing optimization
- ✅ Use mixed instance types (on-demand + spot)
- ✅ Monitor resource utilization
- ✅ Use reserved instances for baseline capacity
- ✅ Implement resource quotas and limits

### 5. Disaster Recovery

- ✅ Enable EFS backup
- ✅ Use EBS snapshots for persistence
- ✅ Document manual procedures
- ✅ Test recovery procedures regularly
- ✅ Use multiple regions if needed

## Common Operations

### Scale Cluster Nodes

Edit `managed_node_groups` in `environments/{env}/main.tf`:

```hcl
managed_node_groups = {
  general = {
    desired_size = 3  # Change this value
    min_size     = 1
    max_size     = 10
  }
}
```

### Update Kubernetes Version

Edit `cluster_version` in `environments/{env}/main.tf`:

```hcl
cluster_version = "1.28"  # Update to new version
```

### Add Fargate Profile

```hcl
fargate_profiles = {
  workloads = {
    fargate_profile_name      = "workloads"
    subnet_ids                = module.vpc.private_subnet_ids
    fargate_profile_namespaces = [
      { namespace = "workloads" },
      { namespace = "kube-system" }
    ]
  }
}
```

## Troubleshooting

### State Lock Issues

If Terraform is stuck on a locked state:

```bash
terraform force-unlock <LOCK_ID>
```

### EKS Cluster Access Denied

Update kubeconfig and verify AWS credentials:

```bash
aws eks update-kubeconfig --region us-east-1 --name dev-eks
aws sts get-caller-identity  # Verify credentials
```

### Nodes Not Joining Cluster

Check security groups and OIDC provider:

```bash
# Verify OIDC provider
aws eks describe-cluster --name dev-eks --query 'cluster.identity.oidc'

# Check node logs
kubectl describe nodes
```

### EFS Mount Failures

Verify CSI driver installation:

```bash
kubectl get pods -n kube-system | grep efs
kubectl describe pvc <pvc-name>
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/enhancement`
3. Make changes following Terraform best practices
4. Format code: `terraform fmt -recursive`
5. Validate: `terraform validate`
6. Commit: `git commit -am 'Add new feature'`
7. Push: `git push origin feature/enhancement`
8. Submit pull request

## License

[Add your license information here]

## Support & Documentation

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Karpenter Documentation](https://karpenter.sh/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

---

**Last Updated**: May 2026 | **Terraform Version**: >= 1.0 | **AWS Provider**: >= 5.0
