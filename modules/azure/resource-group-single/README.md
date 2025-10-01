<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.main_single](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_rg_prop_location_single"></a> [rg\_prop\_location\_single](#input\_rg\_prop\_location\_single) | location of the single resource group | `string` | `null` | no |
| <a name="input_rg_prop_name_single"></a> [rg\_prop\_name\_single](#input\_rg\_prop\_name\_single) | name of the single resource group | `string` | `null` | no |
| <a name="input_rg_prop_tags_single"></a> [rg\_prop\_tags\_single](#input\_rg\_prop\_tags\_single) | tags for the single resource group | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_prop_single"></a> [resource\_group\_prop\_single](#output\_resource\_group\_prop\_single) | All resource group properties |
<!-- END_TF_DOCS -->