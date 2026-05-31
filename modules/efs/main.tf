resource "aws_efs_file_system" "eks" {
  creation_token = var.name

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_efs_mount_target" "zone" {
  for_each = toset(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.eks.id
  subnet_id       = each.value
  security_groups = [var.cluster_primary_security_group_id]
}

resource "kubernetes_storage_class_v1" "efs" {
  metadata {
    name = var.storage_class_name
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.eks.id
    directoryPerms   = "700"
  }

  mount_options = ["iam"]

  depends_on = [aws_efs_mount_target.zone]
}
