variable "initiative_name" {
  description = "The display name of the initiatives to assign to a subscription"
  type        = string
}

variable "assignment_description" {
  type        = string
  description = "A description which should be used for this Policy Assignment."
  default     = null
}

variable "non_compliance_message" {
  type = list(object({
    content                        = string
    policy_definition_reference_id = optional(string)
  }))
  description = <<EOF
One or more non_compliance_message blocks as defined below:
- content: The non-compliance message text. When assigning policy sets (initiatives), unless policy_definition_reference_id is specified then this message will be the default for all policies.
- policy_definition_reference_id: When assigning policy sets (initiatives), this is the ID of the policy definition that the non-compliance message applies to.
EOF
  default     = []
}

variable "assignment_overrides" {
  type = list(object({
    value = string
    selectors = list(object({
      in     = optional(list(string))
      not_in = optional(list(string))
    }))
  }))
  default     = []
  description = <<EOF
One or more overrides blocks as defined below:
- value: Specifies the value to override the policy property. Possible values for policyEffect override listed policy effects.
- selector: One or more override_selector block as defined below:
  - in: Specify the list of policy reference id values to filter in. Cannot be used with not_in.
  - not_in: Specify the list of policy reference id values to filter out. Cannot be used with in.
EOF
}

variable "assignment_resource_selectors" {
  type = list(object({
    name = string
    selectors = list(object({
      kind   = string # resourceLocation, resourceType, or resourceWithoutLocation
      in     = optional(list(string))
      not_in = optional(list(string))
    }))
  }))
  default     = []
  description = <<EOF
One or more resource_selectors blocks as defined below to filter polices by resource properties:
- name: Specifies a name for the resource selector.
- selectors: One or more resource_selector block as defined below:
  - kind: Specifies which characteristic will narrow down the set of evaluated resources. Possible values are resourceLocation, resourceType and resourceWithoutLocation.
  - in: The list of allowed values for the specified kind. Cannot be used with not_in. Can contain up to 50 values.
  - not_in: The list of not-allowed values for the specified kind. Cannot be used with in. Can contain up to 50 values.
EOF
}

variable "assignment_location" {
  description = "The location of this policy initiative assigment"
  type        = string
  default     = null
}

variable "assignment_parameters" {
  description = <<EOF
  A mapping of any parameters for this policy, changing this forces a new policy
  assigment to be created
  EOF
  type        = map(string)
  default     = null
}

variable "enforce" {
  description = "Specifies if this Policy should be enforced or no"
  type        = bool
  default     = false
}

variable "description" {
  description = "The description of the policy set definition"
  type        = string
  default     = null
}

variable "management_group_name" {
  description = "The name of the Management Group where this policy should be defined."
  type        = string
  default     = null
}

variable "policy_definition_list" {
  description = <<EOF
    A collection of policiy defenitions.
    `policy_name`      - Policy name
    `parameter_values` - Parameter values for the referenced policy rule. This field
    is a JSON string that allows you to assign parameters to this policy rule.
    EOF
  type = list(object({
    policy_name      = string
    parameter_values = string
  }))
  default = []
}

variable "scope" {
  description = "Assignment scope for the policy set. Posible values: management_group, subscription"
  type        = string
}

variable "display_name" {
  description = "The display name of the policy set definition."
  type        = string
}

variable "assignment_name" {
  description = "The name of the policy set definition assignment"
  type        = string
  default     = null
}

variable "policy_type" {
  description = "The policy set type. Possible values are BuiltIn or Custom."
  type        = string
  default     = "BuiltIn"
}

variable "initiatives_store" {
  description = "The Management Group where the Policy Set Definition should be stored"
  type        = string
  default     = null
}

variable "create_set_definition" {
  description = "Bool flag to create Policy Set Definition"
  type        = bool
  default     = false
}

variable "assignment_exemptions" {
  type = list(object({
    name                            = string
    exemption_category              = string
    policy_assignment_id            = string
    scope                           = string
    scope_id                        = string
    display_name                    = optional(string)
    description                     = optional(string)
    expires_on                      = optional(string)
    policy_definition_reference_ids = optional(list(string))
    metadata                        = optional(map(string))
  }))
  default     = []
  description = <<EOF
A map of policy‑exemption definitions to create. Each key is an arbitrary identifier; each value supports:

- name (string) — The name of the exemption.  
- exemption_category (string) — The category of the exemption (for example, "Waiver" or "Mitigation").  
- policy_assignment_id (string) — The full resource ID of the policy assignment to exempt.  
- scope_id (string) — The target scope ID (management group ID, subscription ID, resource group name, or resource ID) to which this exemption applies.  
- display_name (optional, string) — A user‑friendly display name for the exemption.  
- description (optional, string) — A description of why this exemption exists.  
- expires_on (optional, string) — Expiration date/time of the exemption, in RFC‑3339 format.  
- policy_definition_reference_ids (optional, list(string)) — One or more policy‑definition IDs within the assignment to exempt.  
- metadata (optional, string) — Freeform map of metadata key‑value pairs.
EOF
}

variable "assignment_exclusions" {
  description = <<EOF
  A list of resource IDs(subscription, resource group, resource) to exclude from this
  policy assignment
  EOF
  type        = list(string)
  default     = []
}

variable "identity" {
  description = ""
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = null
  }
}
