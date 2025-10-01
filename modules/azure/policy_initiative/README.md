<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_group_policy_assignment.policy_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_assignment) | resource |
| [azurerm_management_group_policy_exemption.mg_exemptions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_exemption) | resource |
| [azurerm_policy_set_definition.policy_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition) | resource |
| [azurerm_resource_group_policy_exemption.rg_exemptions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_exemption) | resource |
| [azurerm_resource_policy_exemption.resource_exemptions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_exemption) | resource |
| [azurerm_subscription_policy_assignment.policy_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_assignment) | resource |
| [azurerm_subscription_policy_exemption.subscription_exemptions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_exemption) | resource |
| [azurerm_management_group.mg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_management_group.mg_store](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) | data source |
| [azurerm_policy_definition.policy_definitions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_definition) | data source |
| [azurerm_policy_set_definition.builtin_initiative](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/policy_set_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assignment_description"></a> [assignment\_description](#input\_assignment\_description) | A description which should be used for this Policy Assignment. | `string` | `null` | no |
| <a name="input_assignment_exclusions"></a> [assignment\_exclusions](#input\_assignment\_exclusions) | A list of resource IDs(subscription, resource group, resource) to exclude from this<br/>  policy assignment | `list(string)` | `[]` | no |
| <a name="input_assignment_exemptions"></a> [assignment\_exemptions](#input\_assignment\_exemptions) | A map of policy‑exemption definitions to create. Each key is an arbitrary identifier; each value supports:<br/><br/>- name (string) — The name of the exemption.<br/>- exemption\_category (string) — The category of the exemption (for example, "Waiver" or "Mitigation").<br/>- policy\_assignment\_id (string) — The full resource ID of the policy assignment to exempt.<br/>- scope\_id (string) — The target scope ID (management group ID, subscription ID, resource group name, or resource ID) to which this exemption applies.<br/>- display\_name (optional, string) — A user‑friendly display name for the exemption.<br/>- description (optional, string) — A description of why this exemption exists.<br/>- expires\_on (optional, string) — Expiration date/time of the exemption, in RFC‑3339 format.<br/>- policy\_definition\_reference\_ids (optional, list(string)) — One or more policy‑definition IDs within the assignment to exempt.<br/>- metadata (optional, string) — Freeform map of metadata key‑value pairs. | <pre>list(object({<br/>    name                            = string<br/>    exemption_category              = string<br/>    policy_assignment_id            = string<br/>    scope                           = string<br/>    scope_id                        = string<br/>    display_name                    = optional(string)<br/>    description                     = optional(string)<br/>    expires_on                      = optional(string)<br/>    policy_definition_reference_ids = optional(list(string))<br/>    metadata                        = optional(map(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_assignment_location"></a> [assignment\_location](#input\_assignment\_location) | The location of this policy initiative assigment | `string` | `null` | no |
| <a name="input_assignment_name"></a> [assignment\_name](#input\_assignment\_name) | The name of the policy set definition assignment | `string` | `null` | no |
| <a name="input_assignment_overrides"></a> [assignment\_overrides](#input\_assignment\_overrides) | One or more overrides blocks as defined below:<br/>- value: Specifies the value to override the policy property. Possible values for policyEffect override listed policy effects.<br/>- selector: One or more override\_selector block as defined below:<br/>  - in: Specify the list of policy reference id values to filter in. Cannot be used with not\_in.<br/>  - not\_in: Specify the list of policy reference id values to filter out. Cannot be used with in. | <pre>list(object({<br/>    value = string<br/>    selectors = list(object({<br/>      in     = optional(list(string))<br/>      not_in = optional(list(string))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_assignment_parameters"></a> [assignment\_parameters](#input\_assignment\_parameters) | A mapping of any parameters for this policy, changing this forces a new policy<br/>  assigment to be created | `map(string)` | `null` | no |
| <a name="input_assignment_resource_selectors"></a> [assignment\_resource\_selectors](#input\_assignment\_resource\_selectors) | One or more resource\_selectors blocks as defined below to filter polices by resource properties:<br/>- name: Specifies a name for the resource selector.<br/>- selectors: One or more resource\_selector block as defined below:<br/>  - kind: Specifies which characteristic will narrow down the set of evaluated resources. Possible values are resourceLocation, resourceType and resourceWithoutLocation.<br/>  - in: The list of allowed values for the specified kind. Cannot be used with not\_in. Can contain up to 50 values.<br/>  - not\_in: The list of not-allowed values for the specified kind. Cannot be used with in. Can contain up to 50 values. | <pre>list(object({<br/>    name = string<br/>    selectors = list(object({<br/>      kind   = string # resourceLocation, resourceType, or resourceWithoutLocation<br/>      in     = optional(list(string))<br/>      not_in = optional(list(string))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_create_set_definition"></a> [create\_set\_definition](#input\_create\_set\_definition) | Bool flag to create Policy Set Definition | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the policy set definition | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name of the policy set definition. | `string` | n/a | yes |
| <a name="input_enforce"></a> [enforce](#input\_enforce) | Specifies if this Policy should be enforced or no | `bool` | `false` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | n/a | <pre>object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "identity_ids": null,<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| <a name="input_initiative_name"></a> [initiative\_name](#input\_initiative\_name) | The display name of the initiatives to assign to a subscription | `string` | n/a | yes |
| <a name="input_initiatives_store"></a> [initiatives\_store](#input\_initiatives\_store) | The Management Group where the Policy Set Definition should be stored | `string` | `null` | no |
| <a name="input_management_group_name"></a> [management\_group\_name](#input\_management\_group\_name) | The name of the Management Group where this policy should be defined. | `string` | `null` | no |
| <a name="input_non_compliance_message"></a> [non\_compliance\_message](#input\_non\_compliance\_message) | One or more non\_compliance\_message blocks as defined below:<br/>- content: The non-compliance message text. When assigning policy sets (initiatives), unless policy\_definition\_reference\_id is specified then this message will be the default for all policies.<br/>- policy\_definition\_reference\_id: When assigning policy sets (initiatives), this is the ID of the policy definition that the non-compliance message applies to. | <pre>list(object({<br/>    content                        = string<br/>    policy_definition_reference_id = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_policy_definition_list"></a> [policy\_definition\_list](#input\_policy\_definition\_list) | A collection of policiy defenitions.<br/>    `policy_name`      - Policy name<br/>    `parameter_values` - Parameter values for the referenced policy rule. This field<br/>    is a JSON string that allows you to assign parameters to this policy rule. | <pre>list(object({<br/>    policy_name      = string<br/>    parameter_values = string<br/>  }))</pre> | `[]` | no |
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | The policy set type. Possible values are BuiltIn or Custom. | `string` | `"BuiltIn"` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Assignment scope for the policy set. Posible values: management\_group, subscription | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_set_assignment_identity_id"></a> [policy\_set\_assignment\_identity\_id](#output\_policy\_set\_assignment\_identity\_id) | The Managed Identity block containing Principal Id & Tenant Id of this Policy Set Definition Assignment |
| <a name="output_policy_set_definition_assignment_id"></a> [policy\_set\_definition\_assignment\_id](#output\_policy\_set\_definition\_assignment\_id) | The Policy Set Definition Assignment Id |
| <a name="output_policy_set_definition_id"></a> [policy\_set\_definition\_id](#output\_policy\_set\_definition\_id) | The ID of the Policy Set Definition |
| <a name="output_subscription_policy_assignment_id"></a> [subscription\_policy\_assignment\_id](#output\_subscription\_policy\_assignment\_id) | The Policy Assignment Id |
| <a name="output_subscription_policy_identity_id"></a> [subscription\_policy\_identity\_id](#output\_subscription\_policy\_identity\_id) | The Managed Identity block containing Principal Id & Tenant Id of this Policy Assignment |
<!-- END_TF_DOCS -->