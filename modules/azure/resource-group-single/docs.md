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
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_prop"></a> [resource\_group\_prop](#input\_resource\_group\_prop) | values for resource group properties | <pre>map(object({<br/>        name     = string<br/>        location = string<br/>        tags     = optional(map(string), {})<br/>    }))</pre> | n/a | yes |

## Outputs

No outputs.
