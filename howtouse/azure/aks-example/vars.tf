variable "subscription_id" {
  description = "The Azure subscription ID. By setting the ARM_SUBSCRIPTION_ID environment variable, Terraform will automatically use it for the subscription_id in the azurerm provider block. ||  export TF_VAR_subscription_id='xxxxx-xxxxx-xxxxx-xxxxx-xxxxx' "
}
variable "location" {
  description = "The Azure region where the AKS cluster will be created."
  type        = string
}
variable "name" {
  description = "The name of the resources."
  type        = string
}
variable "default_node_pool" {
  description = "Configuration for the default node pool."
  type = object({
    name       = optional(string, "default")
    node_count = optional(number, 1)
    vm_size    = optional(string, "default")
  })
}
variable "identity" {
  description = "The identity type for the AKS cluster."
  type = object({
    type         = string
    identity_ids = optional(list(string), null)
  })
}
