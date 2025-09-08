provider "azurerm" {}

provider "prefect" {}

data "azurerm_subscription" "this" {}

resource "azurerm_resource_group" "this" {
  name     = var.azure_resource_group_name
  location = var.azure_resource_group_location
}

data "prefect_account" "this" {}
data "prefect_workspace" "this" {}

data "prefect_workspace_role" "this" {
  name = "Worker"
}

resource "prefect_service_account" "this" {
  name              = "aci-worker"
  account_role_name = "Member"
}

resource "prefect_workspace_access" "this" {
  accessor_type     = "SERVICE_ACCOUNT"
  accessor_id       = prefect_service_account.this.id
  workspace_id      = data.prefect_workspace.this.id
  workspace_role_id = data.prefect_workspace_role.this.id
}

# Get the base job templates
data "prefect_worker_metadata" "this" {}

# Terraform doesn't support native deep merging of structures,
# so we use a utility to merge the Prefect Work Pool default config
data "utils_deep_merge_json" "base_job_config" {
  input = [
    data.prefect_worker_metadata.this.base_job_configs.azure_container_instances,
    jsonencode({
      variables = {
        properties = {
          subscription_id = {
            default = data.azurerm_subscription.this.subscription_id
          }
          resource_group_name = {
            default = azurerm_resource_group.this.name
          }
        }
      }
    })
  ]
}

resource "prefect_work_pool" "this" {
  name = "aci-work-pool"
  type = "aci"

  base_job_template = data.utils_deep_merge_json.base_job_config.output
}

module "aci_worker" {
  source  = "prefecthq/aci-worker/prefect"
  version = ">= 0.0.1"

  prefect_api_url = "https://api.prefect.cloud/api/accounts/${data.prefect_account.this.id}/workspaces/${data.prefect_workspace.this.id}"
  prefect_api_key = prefect_service_account.this.api_key

  resource_group_name = azurerm_resource_group.this.name
  work_pool_name      = prefect_work_pool.this.name
}