<!-- BEGIN_TF_DOCS -->
```bash 
By setting the ARM_SUBSCRIPTION_ID environment variable, Terraform will automatically use it for the subscription_id in the azurerm provider block. ||  export ARM_SUBSCRIPTION_ID='xxxxx-xxxxx-xxxxx-xxxxx-xxxxx' 
````

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.0 |
## Providers

No providers.
## Resources

No resources. 
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_prop_mod"></a> [resource\_group\_prop\_mod](#input\_resource\_group\_prop\_mod) | values for resource group properties. Use the key as the name of the resource group | <pre>map(object({<br/>    location = optional(string)<br/>    tags     = optional(map(string), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID. By setting the ARM\_SUBSCRIPTION\_ID environment variable, Terraform will automatically use it for the subscription\_id in the azurerm provider block. \|\|  export ARM\_SUBSCRIPTION\_ID='xxxxx-xxxxx-xxxxx-xxxxx-xxxxx' | `any` | n/a | yes |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group_example_for_each_inside_module"></a> [resource\_group\_example\_for\_each\_inside\_module](#module\_resource\_group\_example\_for\_each\_inside\_module) | ../../../../modules/azure/resource-group | n/a |
| <a name="module_resource_group_example_single_resource_group"></a> [resource\_group\_example\_single\_resource\_group](#module\_resource\_group\_example\_single\_resource\_group) | ../../../../modules/azure/resource-group-single | n/a |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_group_example_for_each_inside_module"></a> [resource\_group\_example\_for\_each\_inside\_module](#output\_resource\_group\_example\_for\_each\_inside\_module) | All resource group properties for for\_each example |
| <a name="output_resource_group_example_single_resource_group"></a> [resource\_group\_example\_single\_resource\_group](#output\_resource\_group\_example\_single\_resource\_group) | All resource group properties when the ouput is a complex map |
| <a name="output_resource_group_example_single_resource_group_all"></a> [resource\_group\_example\_single\_resource\_group\_all](#output\_resource\_group\_example\_single\_resource\_group\_all) | All resource group properties for single example |

  
If you want to remove `resource_group_prop_all` you need to flat the map as `resource_group_example_single_resource_group`

```hcl
+ resource_group_example_single_resource_group_all  = {
      + rg-dev-app  = {
          + resource_group_prop_all = {
              + id         = (known after apply)
              + location   = "eastus"
              + managed_by = null
              + name       = "rg-dev-app"
              + tags       = {
                  + environment = "development"
                  + team        = "app-team"
                }
              + timeouts   = null
            }
        }
      + rg-dev-db   = {
          + resource_group_prop_all = {
              + id         = (known after apply)
              + location   = "westus"
              + managed_by = null
              + name       = "rg-dev-db"
              + tags       = null
              + timeouts   = null
            }
        }
      + rg-prod-app = {
          + resource_group_prop_all = {
              + id         = (known after apply)
              + location   = "eastus"
              + managed_by = null
              + name       = "rg-prod-app"
              + tags       = {
                  + environment = "production"
                  + team        = "app-team"
                }
              + timeouts   = null
            }
        }
      + rg-prod-db  = {
          + resource_group_prop_all = {
              + id         = (known after apply)
              + location   = "westus"
              + managed_by = null
              + name       = "rg-prod-db"
              + tags       = {
                  + environment = "production"
                  + team        = "db-team"
                }
              + timeouts   = null
            }
        }
    }
    ``` 
<!-- END_TF_DOCS -->