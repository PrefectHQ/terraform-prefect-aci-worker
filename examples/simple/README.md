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
| <a name="module_aci_worker"></a> [aci\_worker](#module\_aci\_worker) | .. | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->