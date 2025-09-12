data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  container_instance_name           = coalesce(var.container_instance_name_override, "prefect-worker-${lower(var.work_pool_name)}")
  container_instance_container_name = coalesce(var.container_instance_container_name_override, local.container_instance_name)
}

# User Assigned Managed Identity
resource "azurerm_user_assigned_identity" "this" {
  name                = coalesce(var.user_assigned_identity_name_override, "prefect-${lower(var.work_pool_name)}")
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  tags = var.tags
}

data "azurerm_role_definition" "this" {
  for_each = var.prefect_worker_azure_managed_role_attachment

  name = each.value
}

# Attach Azure Managed roles to the User Identity
resource "azurerm_role_assignment" "this" {
  for_each = var.prefect_worker_azure_managed_role_attachment

  scope              = data.azurerm_resource_group.this.id
  principal_id       = azurerm_user_assigned_identity.this.principal_id
  role_definition_id = data.azurerm_role_definition.this[each.key].role_definition_id
}

# Container Instance for Prefect Worker
resource "azurerm_container_group" "this" {
  name                = local.container_instance_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  os_type             = "Linux"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }

  ip_address_type = var.container_ip_address_type
  subnet_ids      = var.container_subnet_ids

  dns_name_label = var.container_dns_name_label

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
