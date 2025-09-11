variable "work_pool_name" {
  description = "Name for the Prefect work pool"
  type        = string
}

variable "resource_group_name" {
  description = "Name for the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "prefect_api_url" {
  description = "Prefect Cloud API URL (e.g., https://api.prefect.cloud/api/accounts/ACCOUNT_ID/workspaces/WORKSPACE_ID)"
  type        = string
}

variable "prefect_api_key" {
  description = "Prefect Cloud API key"
  type        = string
  sensitive   = true
}

variable "prefect_image_tag" {
  description = "Prefect Docker image tag"
  type        = string
  default     = "prefecthq/prefect:3-python3.11"
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

variable "container_ip_address_type" {
  description = "IP address type for the container group (Public, Private, None)"
  type        = string
  default     = "Public"
}

variable "container_subnet_ids" {
  description = "IDs of the subnets the container instance should be placed in"
  type = set(string)
  default     = null
}

variable "container_dns_name_label" {
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

variable "container_instance_name_override" {
  description = "Overrides the generated Azure Container Instance resource name"
  type        = string
  default     = null
}

variable "container_instance_container_name_override" {
  description = "Overrides the generated Azure Container Instance container resource name"
  type        = string
  default     = null
}