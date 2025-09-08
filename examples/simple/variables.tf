variable "azure_resource_group_name" {
  description = "The Azure Resource Group name to deploy the Prefect ACI worker to"
  type        = string
  default     = "example"
}

variable "prefect_api_url" {
  description = "The API URL for the Prefect instance (e.g. https://api.prefect.cloud/api/accounts/<account_id>/workspace/<workspace_id>"
  type        = string
}

variable "prefect_api_key" {
  description = "The Prefect API key used by this Worker"
  type        = string
  sensitive   = true
}

variable "prefect_work_pool_name" {
  description = "The name of the Prefect Work Pool this ACI instance will be attached to"
  type        = string
  default     = "Terraform-ACI-Example"
}