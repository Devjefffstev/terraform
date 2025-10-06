<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | (Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | (Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | The name of the Key Vault. | `string` | n/a | yes |
| <a name="input_keyvault_objects"></a> [keyvault\_objects](#input\_keyvault\_objects) | n/a | <pre>map(object({<br/>    ## fill this to create a secret<br/>    value = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_legacy_access_policies"></a> [legacy\_access\_policies](#input\_legacy\_access\_policies) | A map of legacy access policies to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.<br/><br/>Requires `var.legacy_access_policies_enabled` to be `true`.<br/><br/>- `object_id` - (Required) The object ID of the principal to assign the access policy to.<br/>- `application_id` - (Optional) The object ID of an Application in Azure Active Directory. Changing this forces a new resource to be created.<br/>- `certifiate_permissions` - (Optional) A list of certificate permissions. Possible values are: `Backup`, `Create`, `Delete`, `DeleteIssuers`, `Get`, `GetIssuers`, `Import`, `List`, `ListIssuers`, `ManageContacts`, `ManageIssuers`, `Purge`, `Recover`, `Restore`, `SetIssuers`, and `Update`.<br/>- `key_permissions` - (Optional) A list of key permissions. Possible value are: `Backup`, `Create`, `Decrypt`, `Delete`, `Encrypt`, `Get`, `Import`, `List`, `Purge`, `Recover`, `Restore`, `Sign`, `UnwrapKey`, `Update`, `Verify`, `WrapKey`, `Release`, `Rotate`, `GetRotationPolicy`, and `SetRotationPolicy`.<br/>- `secret_permissions` - (Optional) A list of secret permissions. Possible values are: `Backup`, `Delete`, `Get`, `List`, `Purge`, `Recover`, `Restore`, and `Set`.<br/>- `storage_permissions` - (Optional) A list of storage permissions. Possible values are: `Backup`, `Delete`, `DeleteSAS`, `Get`, `GetSAS`, `List`, `ListSAS`, `Purge`, `Recover`, `RegenerateKey`, `Restore`, `Set`, `SetSAS`, and `Update`. | <pre>map(object({<br/>    object_id               = string<br/>    application_id          = optional(string, null)<br/>    certificate_permissions = optional(set(string), [])<br/>    key_permissions         = optional(set(string), [])<br/>    secret_permissions      = optional(set(string), [])<br/>    storage_permissions     = optional(set(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the Key Vault. | `string` | `"eastus2"` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | (Optional) A network\_acls block as defined below. | <pre>object({<br/>    bypass                     = string                     # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.<br/>    default_action             = string                     # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.<br/>    ip_rules                   = optional(list(string), []) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.<br/>    virtual_network_subnet_ids = optional(list(string), []) # (Optional) One or more Subnet IDs which should be able to access this Key Vault.<br/>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Whether public network access is allowed for this Key Vault. Defaults to true. | `bool` | `true` | no |
| <a name="input_purge_protection_enabled"></a> [purge\_protection\_enabled](#input\_purge\_protection\_enabled) | (Optional) Is Purge Protection enabled for this Key Vault? | `bool` | `false` | no |
| <a name="input_rbac_authorization_enabled"></a> [rbac\_authorization\_enabled](#input\_rbac\_authorization\_enabled) | (Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Note: Changing the permission model requires unrestricted (no conditions on the role assignment) Microsoft.Authorization/roleAssignments/write permission, which is part of the Owner and User Access Administrator roles. Classic subscription administrator roles like Service Administrator and Co-Administrator, or restricted Key Vault Data Access Administrator cannot be used to change the permission model. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | A map of role assignments to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.<br/><br/>- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.<br/>- `principal_id` - The ID of the principal to assign the role to.<br/>- `description` - The description of the role assignment.<br/>- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.<br/>- `condition` - The condition which will be used to scope the role assignment.<br/>- `condition_version` - The version of the condition syntax. If you are using a condition, valid values are '2.0'.<br/><br/>> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal. | <pre>map(object({<br/>    role_definition_id_or_name             = string<br/>    principal_id                           = string<br/>    description                            = optional(string, null)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>    condition                              = optional(string, null)<br/>    condition_version                      = optional(string, null)<br/>    delegated_managed_identity_resource_id = optional(string, null)<br/>    principal_type                         = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name for the Key Vault. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | (Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. Note: This field can only be configured one time and cannot be updated. | `number` | `90` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID for the Key Vault. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The tenant ID for the Key Vault. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_properties"></a> [key\_vault\_properties](#output\_key\_vault\_properties) | Properties of the key vault |
| <a name="output_keyvault_secret_info"></a> [keyvault\_secret\_info](#output\_keyvault\_secret\_info) | Properties of the key vault secret |
<!-- END_TF_DOCS -->