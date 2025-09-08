# Example usage: Prefect Cloud Deployment

A full example of using the Prefect ACI Worker module to create a work pool in Prefect Cloud.

Deploys a new Azure Resource Group, then creates a managed Identity with a custom Container Contributor role, and finally deploys a Prefect Worker to Azure Container Instances using that identity.

This example also configures the base job configuration to use the correct Azure Subscription ID and Resource Group name.

## Usage

Set the following variables in a `terraform.tfvars` file or through environment variables:

```terraform
azure_resource_group_name = "prefect-aci-rg"
azure_resource_group_location = "eastus"
```

Then run the following commands:

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
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0 |
| <a name="provider_prefect"></a> [prefect](#provider\_prefect) | >= 2.0.0 |
| <a name="provider_utils"></a> [utils](#provider\_utils) | >= 1.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aci_worker"></a> [aci\_worker](#module\_aci\_worker) | prefecthq/aci-worker/prefect | >= 0.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [prefect_service_account.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/resources/service_account) | resource |
| [prefect_work_pool.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/resources/work_pool) | resource |
| [prefect_workspace_access.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/resources/workspace_access) | resource |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [prefect_account.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/data-sources/account) | data source |
| [prefect_worker_metadata.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/data-sources/worker_metadata) | data source |
| [prefect_workspace.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/data-sources/workspace) | data source |
| [prefect_workspace_role.this](https://registry.terraform.io/providers/prefecthq/prefect/latest/docs/data-sources/workspace_role) | data source |
| [utils_deep_merge_json.base_job_config](https://registry.terraform.io/providers/cloudposse/utils/latest/docs/data-sources/deep_merge_json) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_resource_group_location"></a> [azure\_resource\_group\_location](#input\_azure\_resource\_group\_location) | The location of the Azure Resource Group to be created | `string` | `"eastus"` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | The Azure Resource Group name to deploy resources | `string` | `"prefect-aci-worker"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->