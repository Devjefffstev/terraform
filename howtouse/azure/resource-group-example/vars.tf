variable "subscription_id" {
  description = "The Azure subscription ID. By setting the ARM_SUBSCRIPTION_ID environment variable, Terraform will automatically use it for the subscription_id in the azurerm provider block. ||  export TF_VAR_subscription_id='xxxxx-xxxxx-xxxxx-xxxxx-xxxxx' "
}
variable "resource_group_prop_mod" {
  description = "values for resource group properties. Use the key as the name of the resource group"
  type = map(object({
    location = optional(string)
    tags     = optional(map(string), {})
  }))
}
