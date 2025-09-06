# Prefect Worker Azure Container Instances Terraform Module 

⚠️ This project is currently a work in progress and may not be fully functional or stable. Use at your own risk. ⚠️

This module deploys a [Prefect worker](https://docs.prefect.io/v3/concepts/workers) to Azure Container Instances (ACI).

## Requirements

Next, you will need:

- The [Terraform CLI](https://developer.hashicorp.com/terraform/cli)
- The [Prefect CLI](https://docs.prefect.io/v3/get-started/install)
- Your Prefect API URL
- Your Prefect API key, if required

## Usage

```terraform
module "prefect_aci_worker" {
  source = "prefecthq/aci-worker/prefect"

  resource_group_name = "my-resource-group"

  prefect_api_url = var.prefect_api_url
  prefect_api_key = var.prefect_api_key

  work_pool_name = "aci-pool"  
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_group.prefect_worker](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group) | resource |
| [azurerm_role_assignment.container_instances_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.container_instances_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_user_assigned_identity.worker_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefect_api_key"></a> [prefect\_api\_key](#input\_prefect\_api\_key) | Prefect Cloud API key | `string` | n/a | yes |
| <a name="input_prefect_api_url"></a> [prefect\_api\_url](#input\_prefect\_api\_url) | Prefect Cloud API URL (e.g., https://api.prefect.cloud/api/accounts/ACCOUNT_ID/workspaces/WORKSPACE_ID) | `string` | n/a | yes |
| <a name="input_work_pool_name"></a> [work\_pool\_name](#input\_work\_pool\_name) | Name for the Prefect work pool | `string` | n/a | yes |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | CPU allocation for the container | `string` | `"1"` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | Memory allocation for the container in GB | `string` | `"1.5"` | no |
| <a name="input_dns_name_label"></a> [dns\_name\_label](#input\_dns\_name\_label) | DNS name label for the container group | `string` | `null` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | IP address type for the container group (Public, Private, None) | `string` | `"Public"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for resources | `string` | `"eastus"` | no |
| <a name="input_prefect_image_tag"></a> [prefect\_image\_tag](#input\_prefect\_image\_tag) | Prefect Docker image tag | `string` | `"3-latest"` | no |
| <a name="input_registry_name"></a> [registry\_name](#input\_registry\_name) | Name for Azure Container Registry (must be globally unique) | `string` | `"prefectaciregistry"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name for the Azure Resource Group | `string` | `"pre-sales-se"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | <pre>{<br/>  "Environment": "prefect",<br/>  "Purpose": "worker-pool"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_group_name"></a> [container\_group\_name](#output\_container\_group\_name) | Name of the container group |
| <a name="output_managed_identity_id"></a> [managed\_identity\_id](#output\_managed\_identity\_id) | ID of the managed identity |
| <a name="output_managed_identity_principal_id"></a> [managed\_identity\_principal\_id](#output\_managed\_identity\_principal\_id) | Principal ID of the managed identity |
| <a name="output_prefect_ui_configuration"></a> [prefect\_ui\_configuration](#output\_prefect\_ui\_configuration) | Configuration values for Prefect UI work pool setup |
<!-- END_TF_DOCS -->
