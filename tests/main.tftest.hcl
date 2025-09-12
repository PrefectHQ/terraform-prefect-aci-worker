mock_provider "azurerm" {
  mock_data "azurerm_resource_group" {
    defaults = {
      id       = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/test-rg"
      name     = "test-rg"
      location = "eastus"
    }
  }

  mock_data "azurerm_role_definition" {
    defaults = {
      role_definition_id = "/subscriptions/12345678-1234-9876-4563-123456789012/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
    }
  }
  
  mock_resource "azurerm_user_assigned_identity" {
    defaults = {
      id                 = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/prefect-test-pool"
      name               = "prefect-test-pool"
      location           = "eastus"
      resource_group_name = "test-rg"
    }
  }
}

variables {
  work_pool_name      = "test-pool"
  resource_group_name = "test-rg"
  prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
  prefect_api_key     = "test-key"
}

run "validate_variable_inputs_prefect_api_variables" {
  command = plan

  variables {
    work_pool_name      = ""
    resource_group_name = ""
    prefect_api_url     = ""
    prefect_api_key     = ""
  }

  expect_failures = [
    var.prefect_api_url,
    var.prefect_api_key,
    var.resource_group_name
  ]
}

run "validate_resource_names" {
  command = apply

  assert {
    condition     = data.azurerm_resource_group.this.name == var.resource_group_name
    error_message = "Resource group name should match variable"
  }

  assert {
    condition     = data.azurerm_resource_group.this.location == var.location
    error_message = "Resource group location should match variable"
  }

  assert {
    condition     = azurerm_user_assigned_identity.this.name == "prefect-${lower(var.work_pool_name)}"
    error_message = "Managed user identity name should be correctly set"
  }
  
  assert {
    condition = azurerm_container_group.this.name == "prefect-worker-${lower(var.work_pool_name)}"
    error_message = "Container group name should be correctly set"
  }
}

run "validate_container_resources" {
  command = apply

  variables {
    container_cpu       = "2"
    container_memory    = "4"
  }

  assert {
    condition     = azurerm_container_group.this.container[0].cpu == var.container_cpu
    error_message = "Container CPU must be set correctly"
  }

  assert {
    condition     = azurerm_container_group.this.container[0].memory == var.container_memory
    error_message = "Container memory must be set correctly"
  }
}

run "managed_identity_configuration" {
  command = apply

  assert {
    condition     = azurerm_user_assigned_identity.this.resource_group_name == data.azurerm_resource_group.this.name
    error_message = "Managed identity should be in the correct resource group"
  }

  assert {
    condition     = azurerm_user_assigned_identity.this.location == data.azurerm_resource_group.this.location
    error_message = "Managed identity location should match resource group"
  }
  
  assert {
    condition = length(azurerm_role_assignment.this) == length(var.prefect_worker_azure_managed_role_attachment)
    error_message = "All specified roles should be assigned to the managed identity"
  }

  assert {
    condition     = alltrue([for k, v in azurerm_role_assignment.this : contains(var.prefect_worker_azure_managed_role_attachment, k)])
    error_message = "All roles should be assigned to the managed identity"
  }
}

run "container_group_configuration" {
  command = apply

  assert {
    condition     = azurerm_container_group.this.os_type == "Linux"
    error_message = "Container group should use Linux OS"
  }

  assert {
    condition     = length(azurerm_container_group.this.identity) > 0
    error_message = "Container group should have managed identity configured"
  }

  assert {
    condition     = azurerm_container_group.this.identity[0].type == "UserAssigned"
    error_message = "Container group should use UserAssigned identity type"
  }

  assert {
    condition     = contains(azurerm_container_group.this.identity[0].identity_ids, azurerm_user_assigned_identity.this.id)
    error_message = "Container group should use the correct managed identity"
  }
}

run "outputs_validation" {
  command = apply

  assert {
    condition     = output.managed_identity_id != ""
    error_message = "Managed identity ID output should not be empty"
  }

  assert {
    condition     = output.container_group_name != ""
    error_message = "Container group name output should not be empty"
  }
}

# Compliance Tests - Validate tagging and naming conventions
run "tags" {
  command = apply

  variables {
    tags = {
      Environment = "test"
      Purpose     = "worker-pool"
      Owner       = "platform-team"
      CostCenter  = "engineering"
    }
  }

  assert {
    condition     = length(azurerm_user_assigned_identity.this.tags) >= 2
    error_message = "All resources should have minimum required tags"
  }

  assert {
    condition = alltrue([for k, v in var.tags : contains(keys(azurerm_user_assigned_identity.this.tags), k)])
    error_message = "All specified tags should be applied to resources"
  }
  
  assert {
    condition = alltrue([for k, v in var.tags : contains(keys(azurerm_container_group.this.tags), k)])
    error_message = "All specified tags should be applied to resources"
  }
}