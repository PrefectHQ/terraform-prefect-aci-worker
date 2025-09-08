# Example usage: Simple module

This example assumes that you already have an Azure Resource Group, the Prefect Work Pool created, and you just want to deploy a Prefect Worker to ACI in that existing Resource Group.

## Usage

```terraform
azure_resource_group_name = "my-resource-group"
prefect_api_url = "https://api.prefect.cloud/api/accounts/<account_id>/workspace/<workspace_id>"
prefect_api_key = "pnu_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
prefect_work_pool_name = "aci-pool"
```

```bash
terraform init
terraform apply
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0 |
| <a name="requirement_prefect"></a> [prefect](#requirement\_prefect) | >= 2.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aci_worker"></a> [aci\_worker](#module\_aci\_worker) | prefecthq/aci-worker/prefect | >= 0.0.1 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefect_api_key"></a> [prefect\_api\_key](#input\_prefect\_api\_key) | The Prefect API key used by this Worker | `string` | n/a | yes |
| <a name="input_prefect_api_url"></a> [prefect\_api\_url](#input\_prefect\_api\_url) | The API URL for the Prefect instance (e.g. https://api.prefect.cloud/api/accounts/<account\_id>/workspace/<workspace\_id> | `string` | n/a | yes |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | The Azure Resource Group name to deploy the Prefect ACI worker to | `string` | `"example"` | no |
| <a name="input_prefect_work_pool_name"></a> [prefect\_work\_pool\_name](#input\_prefect\_work\_pool\_name) | The name of the Prefect Work Pool this ACI instance will be attached to | `string` | `"Terraform-ACI-Example"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->