variable "azure_resource_group_name" {
  description = "The Azure Resource Group name to deploy resources"
  default     = "prefect-aci-worker"
}

variable "azure_resource_group_location" {
  description = "The location of the Azure Resource Group to be created"
  default     = "eastus"
}