variable "name" {
  description = "The name of the policy definition. Changing this forces a new resource to be created."
  type        = string
}

variable "policy_type" {
  description = <<EOF
    The policy type. Possible values are `BuiltIn`, `Custom`, `NotSpecified` and `Static`. Changing this forces a new resource to be created.
    EOF
  type        = string
  validation {
    condition     = var.policy_type == "BuiltIn" || var.policy_type == "Custom" || var.policy_type == "NotSpecified" || var.policy_type == "Static"
    error_message = "`policy_type`'s possible values are `BuiltIn`, `Custom`, `NotSpecified` and `Static`"
  }
}

variable "mode" {
  description = <<EOF
    The policy resource manager mode that allows you to specify which resource types will be evaluated. Possible values are `All`,
    `Indexed`, `Microsoft.ContainerService.Data`, `Microsoft.CustomerLockbox.Data`, `Microsoft.DataCatalog.Data`, `Microsoft.KeyVault.Data`,
    `Microsoft.Kubernetes.Data`, `Microsoft.MachineLearningServices.Data`, `Microsoft.Network.Data` and `Microsoft.Synapse.Data`.
    EOF
  type        = string
}

variable "display_name" {
  description = "The display name of the policy definition."
  type        = string
}

variable "description" {
  description = "The description of the policy definition."
  type        = string
  default     = null
}

variable "management_group_name" {
  description = "The name of the Management Group where this policy should be defined. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "policy_rule" {
  description = "The policy rule for the policy definition. This is a JSON string representing the rule that contains an if and a then block."
  type        = string
  default     = null
}

variable "metadata" {
  description = <<EOF
    The metadata for the policy definition. This is a JSON string representing additional metadata that
    should be stored with the policy definition.
    EOF
  type        = string
  default     = null
}

variable "parameters" {
  description = "Parameters for the policy definition. This field is a JSON string that allows you to parameterize your policy definition."
  type        = string
  default     = null
}
