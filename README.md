# Prefect Worker Azure Container Instances Terraform Module 

⚠️ This project is currently a work in progress and may not be fully functional or stable. Use at your own risk. ⚠️

This module deploys a [Prefect worker](https://docs.prefect.io/v3/concepts/workers) to Azure Container Instances (ACI).

## Requirements

Next, you will need:

- The [Terraform CLI](https://developer.hashicorp.com/terraform/cli)
- The [Prefect CLI](https://docs.prefect.io/v3/get-started/install)
- The [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
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
| [azurerm_container_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefect_api_key"></a> [prefect\_api\_key](#input\_prefect\_api\_key) | Prefect Cloud API key | `string` | n/a | yes |
| <a name="input_prefect_api_url"></a> [prefect\_api\_url](#input\_prefect\_api\_url) | Prefect Cloud API URL (e.g., https://api.prefect.cloud/api/accounts/ACCOUNT_ID/workspaces/WORKSPACE_ID) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name for the Azure Resource Group | `string` | n/a | yes |
| <a name="input_work_pool_name"></a> [work\_pool\_name](#input\_work\_pool\_name) | Name for the Prefect work pool | `string` | n/a | yes |
| <a name="input_container_commands_override"></a> [container\_commands\_override](#input\_container\_commands\_override) | Specifying this overrides the default container command for the Prefect Worker | `list(string)` | `null` | no |
| <a name="input_container_cpu"></a> [container\_cpu](#input\_container\_cpu) | CPU allocation for the container | `number` | `1` | no |
| <a name="input_container_dns_name_label"></a> [container\_dns\_name\_label](#input\_container\_dns\_name\_label) | DNS name label for the container group | `string` | `null` | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Container image for the Prefect Worker | `string` | `"prefecthq/prefect:3-python3.11"` | no |
| <a name="input_container_instance_container_name_override"></a> [container\_instance\_container\_name\_override](#input\_container\_instance\_container\_name\_override) | Overrides the generated Azure Container Instance container resource name | `string` | `null` | no |
| <a name="input_container_instance_name_override"></a> [container\_instance\_name\_override](#input\_container\_instance\_name\_override) | Overrides the generated Azure Container Instance resource name | `string` | `null` | no |
| <a name="input_container_ip_address_type"></a> [container\_ip\_address\_type](#input\_container\_ip\_address\_type) | IP address type for the container group (Public, Private, None) | `string` | `"Public"` | no |
| <a name="input_container_memory"></a> [container\_memory](#input\_container\_memory) | Memory allocation for the container in GB | `number` | `1.5` | no |
| <a name="input_container_subnet_ids"></a> [container\_subnet\_ids](#input\_container\_subnet\_ids) | IDs of the subnets the container instance should be placed in | `set(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for resources | `string` | `"eastus"` | no |
| <a name="input_prefect_worker_azure_managed_role_attachment"></a> [prefect\_worker\_azure\_managed\_role\_attachment](#input\_prefect\_worker\_azure\_managed\_role\_attachment) | Azure Managed roles to attach to the Prefect Worker's Azure User Assigned Identity | `set(string)` | <pre>[<br/>  "Azure Container Instances Contributor Role",<br/>  "Managed Identity Operator"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity_name_override"></a> [user\_assigned\_identity\_name\_override](#input\_user\_assigned\_identity\_name\_override) | Override the generated User Assigned Identity name | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_group_name"></a> [container\_group\_name](#output\_container\_group\_name) | Name of the container group |
| <a name="output_managed_identity_id"></a> [managed\_identity\_id](#output\_managed\_identity\_id) | ID of the managed identity |
| <a name="output_managed_identity_principal_id"></a> [managed\_identity\_principal\_id](#output\_managed\_identity\_principal\_id) | Principal ID of the managed identity |
<!-- END_TF_DOCS -->
