provider "azurerm" {}
provider "prefect" {}

module "aci_worker" {
  source = "prefecthq/aci-worker/prefect"
  version = ">= 0.0.1"

  prefect_api_url = var.prefect_api_url
  prefect_api_key = var.prefect_api_key

  resource_group_name = var.azure_resource_group_name
  work_pool_name = var.prefect_work_pool_name
}