mock_provider "azurerm" {}

run "validate_resource_names" {
  command = plan

  variables {
    work_pool_name      = "test-pool"
    registry_name       = "testregistry123"
    resource_group_name = "test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
  }

  assert {
    condition     = var.work_pool_name == "test-pool"
    error_message = "Work pool name should match input"
  }

  assert {
    condition     = length(var.registry_name) >= 5 && length(var.registry_name) <= 50
    error_message = "Registry name must be between 5 and 50 characters"
  }

  assert {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.registry_name))
    error_message = "Registry name must contain only alphanumeric characters"
  }

  assert {
    condition     = contains(["eastus", "westus", "westus2", "centralus", "northcentralus", "southcentralus", "eastus2", "westeurope", "northeurope"], var.location)
    error_message = "Location must be a valid Azure region"
  }

  assert {
    condition     = can(regex("^https://api\\.prefect\\.cloud/api/accounts/.+/workspaces/.+$", var.prefect_api_url))
    error_message = "Prefect API URL must be in the correct format"
  }
}

run "validate_container_resources" {
  command = plan

  variables {
    work_pool_name      = "test-pool"
    registry_name       = "testregistry123"
    resource_group_name = "test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
    container_cpu       = "2"
    container_memory    = "4"
  }

  assert {
    condition     = tonumber(var.container_cpu) >= 1 && tonumber(var.container_cpu) <= 4
    error_message = "Container CPU must be between 1 and 4"
  }

  assert {
    condition     = tonumber(var.container_memory) >= 0.5 && tonumber(var.container_memory) <= 14
    error_message = "Container memory must be between 0.5 and 14 GB"
  }
}

# Integration Tests - Test resource creation and configuration
run "resource_group_configuration" {
  command = plan

  variables {
    work_pool_name      = "integration-test-pool"
    registry_name       = "integrationtest123"
    resource_group_name = "integration-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
  }

  assert {
    condition     = azurerm_resource_group.main.name == var.resource_group_name
    error_message = "Resource group name should match variable"
  }

  assert {
    condition     = azurerm_resource_group.main.location == var.location
    error_message = "Resource group location should match variable"
  }

  assert {
    condition     = length(azurerm_resource_group.main.tags) > 0
    error_message = "Resource group should have tags"
  }
}

run "managed_identity_configuration" {
  command = plan

  variables {
    work_pool_name      = "integration-test-pool"
    registry_name       = "integrationtest123"
    resource_group_name = "integration-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
  }

  assert {
    condition     = azurerm_user_assigned_identity.worker_identity.name == "${var.work_pool_name}-identity"
    error_message = "Managed identity name should follow naming convention"
  }

  assert {
    condition     = azurerm_user_assigned_identity.worker_identity.resource_group_name == azurerm_resource_group.main.name
    error_message = "Managed identity should be in the correct resource group"
  }

  assert {
    condition     = azurerm_user_assigned_identity.worker_identity.location == azurerm_resource_group.main.location
    error_message = "Managed identity location should match resource group"
  }
}

run "container_registry_configuration" {
  command = plan

  variables {
    work_pool_name      = "integration-test-pool"
    registry_name       = "integrationtest123"
    resource_group_name = "integration-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
  }

  assert {
    condition     = azurerm_container_registry.main.name == var.registry_name
    error_message = "Container registry name should match variable"
  }

  assert {
    condition     = azurerm_container_registry.main.sku == "Basic"
    error_message = "Container registry should use Basic SKU"
  }

  assert {
    condition     = azurerm_container_registry.main.admin_enabled == true
    error_message = "Container registry admin should be enabled"
  }
}

run "role_assignments_configuration" {
  command = plan

  variables {
    work_pool_name      = "integration-test-pool"
    registry_name       = "integrationtest123"
    resource_group_name = "integration-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
  }

  assert {
    condition     = azurerm_role_assignment.container_instances_contributor.scope == azurerm_resource_group.main.id
    error_message = "Container Instances Contributor role should be scoped to resource group"
  }

  assert {
    condition     = azurerm_role_assignment.acr_pull.scope == azurerm_resource_group.main.id
    error_message = "AcrPull role should be scoped to resource group"
  }

  assert {
    condition     = azurerm_role_assignment.container_instances_contributor.principal_id == azurerm_user_assigned_identity.worker_identity.principal_id
    error_message = "Role assignment should use correct managed identity principal"
  }
}

run "container_group_configuration" {
  command = plan

  variables {
    work_pool_name      = "integration-test-pool"
    registry_name       = "integrationtest123"
    resource_group_name = "integration-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
  }

  assert {
    condition     = azurerm_container_group.prefect_worker.name == var.work_pool_name
    error_message = "Container group name should match work pool name"
  }

  assert {
    condition     = azurerm_container_group.prefect_worker.os_type == "Linux"
    error_message = "Container group should use Linux OS"
  }

  assert {
    condition     = length(azurerm_container_group.prefect_worker.identity) > 0
    error_message = "Container group should have managed identity configured"
  }

  assert {
    condition     = azurerm_container_group.prefect_worker.identity[0].type == "UserAssigned"
    error_message = "Container group should use UserAssigned identity type"
  }

  assert {
    condition     = contains(azurerm_container_group.prefect_worker.identity[0].identity_ids, azurerm_user_assigned_identity.worker_identity.id)
    error_message = "Container group should use the correct managed identity"
  }
}

run "outputs_validation" {
  command = plan

  variables {
    work_pool_name      = "integration-test-pool"
    registry_name       = "integrationtest123"
    resource_group_name = "integration-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
  }

  assert {
    condition     = output.resource_group_name == var.resource_group_name
    error_message = "Output resource_group_name should match input"
  }

  assert {
    condition     = output.managed_identity_id != ""
    error_message = "Managed identity ID output should not be empty"
  }

  assert {
    condition     = output.container_registry_name == var.registry_name
    error_message = "Container registry name output should match input"
  }

  assert {
    condition     = can(regex(".*\\.azurecr\\.io$", output.container_registry_login_server))
    error_message = "Container registry login server should be a valid ACR URL"
  }
}

# End-to-End Tests - Would require actual Azure resources (commented out for safety)
/*
run "end_to_end_deployment" {
  command = apply

  variables {
    work_pool_name      = "e2e-test-pool"
    registry_name       = "e2etest${random_string.suffix.result}"
    resource_group_name = "e2e-test-rg"
    location           = "eastus"
    prefect_api_url    = var.prefect_api_url
    prefect_api_key    = var.prefect_api_key
  }

  assert {
    condition     = output.resource_group_name != ""
    error_message = "Resource group should be created successfully"
  }

  assert {
    condition     = output.managed_identity_id != ""
    error_message = "Managed identity should be created successfully"
  }

  assert {
    condition     = output.container_registry_name != ""
    error_message = "Container registry should be created successfully"
  }

  assert {
    condition     = output.container_group_name != ""
    error_message = "Container group should be created successfully"
  }
}

# Generate random suffix for unique naming in E2E tests
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
*/

# Performance Tests - Validate resource configurations meet performance requirements
run "performance_requirements" {
  command = plan

  variables {
    work_pool_name      = "perf-test-pool"
    registry_name       = "perftest123"
    resource_group_name = "perf-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
    container_cpu       = "2"
    container_memory    = "4"
  }

  assert {
    condition     = tonumber(azurerm_container_group.prefect_worker.container[0].cpu) >= 1
    error_message = "Container should have at least 1 CPU for adequate performance"
  }

  assert {
    condition     = tonumber(azurerm_container_group.prefect_worker.container[0].memory) >= 1
    error_message = "Container should have at least 1GB memory for adequate performance"
  }

  assert {
    condition     = azurerm_container_registry.main.sku == "Basic"
    error_message = "ACR should use at least Basic SKU for production workloads"
  }
}

# Security Tests - Validate security configurations
run "security_configuration" {
  command = plan

  variables {
    work_pool_name      = "security-test-pool"
    registry_name       = "securitytest123"
    resource_group_name = "security-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
  }

  assert {
    condition     = length(azurerm_container_group.prefect_worker.container[0].secure_environment_variables) > 0
    error_message = "Container should use secure environment variables for sensitive data"
  }

  assert {
    condition     = contains(keys(azurerm_container_group.prefect_worker.container[0].secure_environment_variables), "PREFECT_API_KEY")
    error_message = "Prefect API key should be stored as secure environment variable"
  }

  assert {
    condition     = azurerm_user_assigned_identity.worker_identity.name != ""
    error_message = "Managed identity should be configured for secure authentication"
  }

  assert {
    condition     = length(azurerm_role_definition.container_instances_contributor.permissions[0].actions) > 0
    error_message = "Custom role should have specific permissions defined"
  }
}

# Compliance Tests - Validate tagging and naming conventions
run "compliance_standards" {
  command = plan

  variables {
    work_pool_name      = "compliance-test-pool"
    registry_name       = "compliancetest123"
    resource_group_name = "compliance-test-rg"
    location            = "eastus"
    prefect_api_url     = "https://api.prefect.cloud/api/accounts/test/workspaces/test"
    prefect_api_key     = "test-key"
    tags = {
      Environment = "test"
      Purpose     = "worker-pool"
      Owner       = "platform-team"
      CostCenter  = "engineering"
    }
  }

  assert {
    condition     = length(azurerm_resource_group.main.tags) >= 2
    error_message = "All resources should have minimum required tags"
  }

  assert {
    condition     = contains(keys(azurerm_resource_group.main.tags), "Environment")
    error_message = "Resources should have Environment tag"
  }

  assert {
    condition     = contains(keys(azurerm_resource_group.main.tags), "Purpose")
    error_message = "Resources should have Purpose tag"
  }

  assert {
    condition     = can(regex("^[a-z0-9-]+$", var.work_pool_name))
    error_message = "Work pool name should follow lowercase naming convention"
  }
}