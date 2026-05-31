variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster ID used by the Kubernetes add-ons module"
}

variable "enable_amazon_eks_aws_ebs_csi_driver" {
  type        = bool
  description = "Enable AWS EBS CSI driver add-on"
  default     = true
}

variable "enable_aws_efs_csi_driver" {
  type        = bool
  description = "Enable AWS EFS CSI driver helm-based add-on"
  default     = true
}

variable "aws_efs_csi_driver_helm_config" {
  type = map(string)
  description = "Helm configuration values for the AWS EFS CSI driver"
  default = {
    repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
    version    = "2.4.0"
    namespace  = "kube-system"
  }
}

variable "enable_aws_load_balancer_controller" {
  type        = bool
  description = "Enable AWS Load Balancer Controller"
  default     = true
}

variable "enable_metrics_server" {
  type        = bool
  description = "Enable Metrics Server add-on"
  default     = true
}

variable "enable_cert_manager" {
  type        = bool
  description = "Enable cert-manager add-on"
  default     = true
}

variable "enable_karpenter" {
  type        = bool
  description = "Enable Karpenter add-on"
  default     = true
}

variable "karpenter_helm_config" {
  type = map(string)
  description = "Helm configuration for Karpenter"
  default = {
    name       = "karpenter"
    chart      = "karpenter"
    repository = "oci://public.ecr.aws/karpenter"
    version    = "v0.27.0"
    namespace  = "karpenter"
  }
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags for add-on resources"
  default     = {}
}
