variable "work_pool_name" {
  description = "Name for the Prefect work pool"
  type        = string
}

variable "resource_group_name" {
  description = "Name for the Azure Resource Group"
  type        = string

  validation {
    condition     = var.resource_group_name != ""
    error_message = "Variable `resource_group_name` must be defined"
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "user_assigned_identity_name_override" {
  description = "Override the generated User Assigned Identity name"
  type        = string
  default     = null

  validation {
    condition     = var.user_assigned_identity_name_override == null ? true : (length(var.user_assigned_identity_name_override) > 0 && length(var.user_assigned_identity_name_override) <= 24)
    error_message = "Name must be less than 24 characters."
  }

  validation {
    condition     = var.user_assigned_identity_name_override == null ? true : can(regex("^[A-Za-z0-9_-]+$", var.user_assigned_identity_name_override))
    error_message = "The value may only contain alphanumeric characters, underscores, and dashes."
  }
}

variable "prefect_worker_azure_managed_role_attachment" {
  description = "Azure Managed roles to attach to the Prefect Worker's Azure User Assigned Identity"
  type        = set(string)
  default = [
    "Azure Container Instances Contributor Role",
    "Managed Identity Operator"
  ]
}

variable "prefect_api_url" {
  description = "Prefect Cloud API URL (e.g., https://api.prefect.cloud/api/accounts/ACCOUNT_ID/workspaces/WORKSPACE_ID)"
  type        = string

  validation {
    condition     = var.prefect_api_url != ""
    error_message = "Variable `prefect_api_url` must be defined"
  }
}

variable "prefect_api_key" {
  description = "Prefect Cloud API key"
  type        = string
  sensitive   = true

  validation {
    condition     = var.prefect_api_key != ""
    error_message = "Variable `prefect_api_key` must be defined"
  }
}

variable "container_image" {
  description = "Container image for the Prefect Worker"
  type        = string
  default     = "prefecthq/prefect:3-python3.11"
}

variable "container_cpu" {
  description = "CPU allocation for the container"
  type        = number
  default     = 1
}

variable "container_memory" {
  description = "Memory allocation for the container in GB"
  type        = number
  default     = 1.5
}

variable "container_commands_override" {
  description = "Specifying this overrides the default container command for the Prefect Worker"
  type        = list(string)
  default     = null
}

variable "container_ip_address_type" {
  description = "IP address type for the container group (Public, Private, None)"
  type        = string
  default     = "Public"
}

variable "container_subnet_ids" {
  description = "IDs of the subnets the container instance should be placed in"
  type        = set(string)
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
  default     = {}
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