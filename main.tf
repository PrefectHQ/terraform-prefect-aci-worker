data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  container_instance_name           = coalesce(var.container_instance_name_override, "prefect-worker-${lower(var.work_pool_name)}")
  container_instance_container_name = coalesce(var.container_instance_container_name_override, local.container_instance_name)
}

# User Assigned Managed Identity
resource "azurerm_user_assigned_identity" "worker_identity" {
  name                = "${var.work_pool_name}-identity"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  tags = var.tags
}

# Custom Role Definition for Container Instances
resource "azurerm_role_definition" "container_instances_contributor" {
  name        = "Container Instances Contributor"
  scope       = data.azurerm_resource_group.this.id
  description = "Can create, delete, and monitor container instances."

  permissions {
    actions = [
      "Microsoft.ManagedIdentity/userAssignedIdentities/assign/action",
      "Microsoft.Resources/deployments/*",
      "Microsoft.ContainerInstance/containerGroups/*"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_resource_group.this.id
  ]
}

# Role Assignment: Container Instances Contributor
resource "azurerm_role_assignment" "container_instances_contributor" {
  scope              = data.azurerm_resource_group.this.id
  role_definition_id = azurerm_role_definition.container_instances_contributor.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.worker_identity.principal_id
}

# Container Instance for Prefect Worker
resource "azurerm_container_group" "prefect_worker" {
  name                = local.container_instance_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  os_type             = "Linux"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.worker_identity.id]
  }

  ip_address_type = var.container_ip_address_type
  subnet_ids = var.container_subnet_ids

  dns_name_label  = var.container_dns_name_label

  container {
    name   = local.container_instance_container_name
    image  = var.prefect_image_tag
    cpu    = var.container_cpu
    memory = var.container_memory

    commands = [
      "/bin/bash",
      "-c",
      "pip install prefect-azure && prefect worker start --pool ${var.work_pool_name} --type azure-container-instance"
    ]

    secure_environment_variables = {
      PREFECT_API_URL = var.prefect_api_url
      PREFECT_API_KEY = var.prefect_api_key
    }

    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.container_ip_address_type == "Public" && var.container_dns_name_label == null
      error_message = "dns_name_label must be defined when ip_address_type is 'Public'"
    }
  }
}
