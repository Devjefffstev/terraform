variable "name" {
  description = "The name of the AKS cluster."
  type        = string
}
variable "location" {
  description = "The Azure region where the AKS cluster will be created."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group where the AKS cluster will be created."
  type        = string
}
variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
}
variable "default_node_pool" {
  description = "Configuration for the default node pool."
  type = object({
    name       = string
    node_count = number
    vm_size    = string
  })
}
variable "identity" {
  description = "The identity type for the AKS cluster."
  type = object({
    type         = string
    identity_ids = optional(list(string), null)
  })
  validation {
    condition     = (contains(["UserAssigned"], var.identity.type) && !(var.identity.identity_ids == null)) || (contains(["SystemAssigned"], var.identity.type) && var.identity.identity_ids == null)
    error_message = <<-EOF
      The identity type must be either "SystemAssigned" or "UserAssigned".
      If "UserAssigned" is selected, identity_ids must not be null.
      If "SystemAssigned" is selected, identity_ids must be null.
      EOF
  }
}
variable "sku_tier" {
  description = "The SKU tier for the AKS cluster. Defaults to 'Free'."
  type        = string
  default     = "Free"  
}
variable "tags" {
  description = "A map of tags to assign to the AKS cluster."
  type        = map(string)
  default     = null
}
