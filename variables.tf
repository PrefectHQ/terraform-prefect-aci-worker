variable "work_pool_name" {
  description = "Name for the Prefect work pool"
  type        = string
}

variable "registry_name" {
  description = "Name for Azure Container Registry (must be globally unique)"
  type        = string
  default     = "prefectaciregistry"
}

variable "resource_group_name" {
  description = "Name for the Azure Resource Group"
  type        = string
  default     = "pre-sales-se"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "prefect_api_url" {
  description = "Prefect Cloud API URL (e.g., https://api.prefect.cloud/api/accounts/ACCOUNT_ID/workspaces/WORKSPACE_ID)"
  type        = string
  sensitive   = true
}

variable "prefect_api_key" {
  description = "Prefect Cloud API key"
  type        = string
  sensitive   = true
}

variable "prefect_image_tag" {
  description = "Prefect Docker image tag"
  type        = string
  default     = "3-latest"
}

variable "container_cpu" {
  description = "CPU allocation for the container"
  type        = string
  default     = "1"
}

variable "container_memory" {
  description = "Memory allocation for the container in GB"
  type        = string
  default     = "1.5"
}

variable "ip_address_type" {
  description = "IP address type for the container group (Public, Private, None)"
  type        = string
  default     = "Public"
}

variable "dns_name_label" {
  description = "DNS name label for the container group"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "prefect"
    Purpose     = "worker-pool"
  }
}