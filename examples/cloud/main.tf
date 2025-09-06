terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
    prefect = {
      source  = "prefecthq/prefect"
      version = ">= 2.0.0"
    }
  }
}

provider "azurerm" {}

provider "prefect" {}

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

resource "prefect_work_pool" "this" {
  name = "aci-work-pool"
  type = "aci"
}

module "aci_worker" {
  source = ".."
  # source = "prefecthq/aci-worker/prefect"
  # version = "0.0.1"

  prefect_api_url = "https://api.prefect.cloud/api/accounts/${data.prefect_account.this.id}/workspaces/${data.prefect_workspace.this.id}"
  prefect_api_key = prefect_service_account.this.api_key

  work_pool_name = prefect_work_pool.this.name
}