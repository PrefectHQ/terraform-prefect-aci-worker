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
    utils = {
      source  = "cloudposse/utils"
      version = ">= 1.0.0"
    }
  }
}