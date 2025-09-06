output "managed_identity_id" {
  description = "ID of the managed identity"
  value       = azurerm_user_assigned_identity.worker_identity.id
}

output "managed_identity_principal_id" {
  description = "Principal ID of the managed identity"
  value       = azurerm_user_assigned_identity.worker_identity.principal_id
}

output "container_group_name" {
  description = "Name of the container group"
  value       = azurerm_container_group.prefect_worker.name
}

output "prefect_ui_configuration" {
  description = "Configuration values for Prefect UI work pool setup"
  value = {
    identities        = [azurerm_user_assigned_identity.worker_identity.id]
    resource_group_id = data.azurerm_resource_group.this.id
  }
}