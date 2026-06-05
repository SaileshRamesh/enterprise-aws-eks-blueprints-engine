provider "kubectl" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_id]
  }
}

# Creates Karpenter native node termination handler resources and IAM instance profile
module "karpenter" {
  source  = var.karpenter_module_source
  version = var.karpenter_module_version

  cluster_name           = var.cluster_id
  irsa_oidc_provider_arn = var.irsa_oidc_provider_arn
  create_irsa            = var.create_irsa

  tags = merge(var.tags, {
    managed_by = "terraform"
  })
}

resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
---
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  ttlSecondsAfterEmpty: ${var.provisioner_ttl_seconds_after_empty}
  ttlSecondsUntilExpired: ${var.provisioner_ttl_seconds_until_expired}
  limits:
    resources:
      cpu: ${var.provisioner_cpu_limit}
  requirements:
    - key: karpenter.k8s.aws/instance-family
      operator: In
      values: ${jsonencode(var.provisioner_instance_families)}
    - key: karpenter.k8s.aws/instance-size
      operator: NotIn
      values: ${jsonencode(var.provisioner_excluded_instance_sizes)}
  providerRef:
    name: default
YAML
}

resource "kubectl_manifest" "karpenter_template" {
  yaml_body = <<-YAML
---
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeTemplate
metadata:
    name: default
spec:
  subnetSelector:
    "kubernetes.io/cluster/${var.cluster_id}": "owned"
  securityGroupSelector:
    "kubernetes.io/cluster/${var.cluster_id}": "owned"
  instanceProfile: ${module.karpenter.instance_profile_name}
  tags:
    "kubernetes.io/cluster/${var.cluster_id}": "owned"
YAML
}
