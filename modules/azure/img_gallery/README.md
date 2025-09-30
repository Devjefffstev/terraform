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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compute_gallery"></a> [compute\_gallery](#module\_compute\_gallery) | Azure/avm-res-compute-gallery/azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_shared_image_version.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | n/a | `bool` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) Azure region where the resource should be deployed. | `string` | n/a | yes |
| <a name="input_lock"></a> [lock](#input\_lock) | n/a | <pre>object({ kind = string<br/>  name = optional(string, null) })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Shared Image Gallery. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The resource group where the resources will be deployed. | `string` | n/a | yes |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | n/a | <pre>map(object({ role_definition_id_or_name = string<br/>    principal_id                           = string<br/>    description                            = optional(string, null)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>    condition                              = optional(string, null)<br/>    condition_version                      = optional(string, null)<br/>    delegated_managed_identity_resource_id = optional(string, null)<br/>  principal_type = optional(string, null) }))</pre> | `{}` | no |
| <a name="input_shared_image_definitions"></a> [shared\_image\_definitions](#input\_shared\_image\_definitions) | Define shared image definition | <pre>map(<br/>    object({<br/>      name = string<br/>      identifier = object({<br/>        publisher = string<br/>        offer     = string<br/>        sku       = string<br/>      })<br/>      os_type = string<br/>      purchase_plan = optional(<br/>        object({<br/>          name      = string<br/>          publisher = optional(string)<br/>          product   = optional(string)<br/>        })<br/>      )<br/>      description                         = optional(string)<br/>      disk_types_not_allowed              = optional(list(string))<br/>      end_of_life_date                    = optional(string)<br/>      eula                                = optional(string)<br/>      specialized                         = optional(bool)<br/>      architecture                        = optional(string, "x64")<br/>      hyper_v_generation                  = optional(string, "V1")<br/>      max_recommended_vcpu_count          = optional(number)<br/>      min_recommended_vcpu_count          = optional(number)<br/>      max_recommended_memory_in_gb        = optional(number)<br/>      min_recommended_memory_in_gb        = optional(number)<br/>      privacy_statement_uri               = optional(string)<br/>      release_note_uri                    = optional(string)<br/>      trusted_launch_enabled              = optional(bool)<br/>      confidential_vm_supported           = optional(bool)<br/>      confidential_vm_enabled             = optional(bool)<br/>      accelerated_network_support_enabled = optional(bool)<br/>      tags                                = optional(map(string))<br/>      image_version = optional(list(object({<br/>        image_name       = string<br/>        managed_image_id = optional(string)<br/>        target_region = object({<br/>          name                   = string<br/>          regional_replica_count = string<br/>          storage_account_type   = string<br/>        })<br/>      })))<br/>    })<br/>  )</pre> | `{}` | no |
| <a name="input_sharing"></a> [sharing](#input\_sharing) | n/a | <pre>object({ permission = string<br/>    community_gallery = optional(object({ eula = string<br/>      prefix          = string<br/>      publisher_email = string<br/>  publisher_uri = string })) })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags to be applied to the resources. | `map(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | n/a | <pre>object({ create = optional(string)<br/>    delete = optional(string)<br/>    read   = optional(string)<br/>  update = optional(string) })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_shared_image_galleries"></a> [shared\_image\_galleries](#output\_shared\_image\_galleries) | # Outputs for the local values |
| <a name="output_shared_images_created"></a> [shared\_images\_created](#output\_shared\_images\_created) | n/a |
<!-- END_TF_DOCS -->