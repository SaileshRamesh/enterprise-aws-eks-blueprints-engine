output "efs_file_system_id" {
  description = "The ID of the created EFS file system."
  value       = aws_efs_file_system.eks.id
}

output "efs_mount_target_ids" {
  description = "IDs of the created EFS mount targets."
  value       = values(aws_efs_mount_target.zone)[*].id
}

output "efs_storage_class_name" {
  description = "The name of the created Kubernetes EFS StorageClass."
  value       = kubernetes_storage_class_v1.efs.metadata[0].name
}
