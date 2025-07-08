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
  default = {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }  
}
variable "identity" {
  description = "The identity type for the AKS cluster."
  type        = object({
    type = string
    identity_ids = optional(list(string), null)
  })
  validation {
    condition = contains(["UserAssigned"], var.identity.type) && var.identity.identity_ids == null
    error_message = "identity_ids must be provided when identity type is UserAssigned."
  }  
}
variable "tags" {
  description = "A map of tags to assign to the AKS cluster."
  type        = map(string)
  default     = null
}
