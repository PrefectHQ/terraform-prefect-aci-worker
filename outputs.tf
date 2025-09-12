output "managed_identity_id" {
  description = "ID of the managed identity"
  value       = azurerm_user_assigned_identity.this.id
}

output "managed_identity_principal_id" {
  description = "Principal ID of the managed identity"
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "container_group_name" {
  description = "Name of the container group"
  value       = azurerm_container_group.this.name
}
