# Define Azure region
variable "location" {
  type        = string
  description = "(Required) Azure region where the resource should be deployed."
}

# Define name of the Shared Image Gallery
variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Shared Image Gallery. Changing this forces a new resource to be created."
}

# Define resource group name
variable "resource_group_name" {
  type        = string
  description = "(Optional) The resource group where the resources will be deployed."
}


variable "enable_telemetry" {
  type    = bool
  default = null
}

variable "lock" {
  type = object({ kind = string
  name = optional(string, null) })
  default = null
}

variable "role_assignments" {
  type = map(object({ role_definition_id_or_name = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  principal_type = optional(string, null) }))
  default = {}

}

# Define shared image definition
variable "shared_image_definitions" {
  type = map(
    object({
      name = string
      identifier = object({
        publisher = string
        offer     = string
        sku       = string
      })
      os_type = string
      purchase_plan = optional(
        object({
          name      = string
          publisher = optional(string)
          product   = optional(string)
        })
      )
      description                         = optional(string)
      disk_types_not_allowed              = optional(list(string))
      end_of_life_date                    = optional(string)
      eula                                = optional(string)
      specialized                         = optional(bool)
      architecture                        = optional(string, "x64")
      hyper_v_generation                  = optional(string, "V1")
      max_recommended_vcpu_count          = optional(number)
      min_recommended_vcpu_count          = optional(number)
      max_recommended_memory_in_gb        = optional(number)
      min_recommended_memory_in_gb        = optional(number)
      privacy_statement_uri               = optional(string)
      release_note_uri                    = optional(string)
      trusted_launch_enabled              = optional(bool)
      confidential_vm_supported           = optional(bool)
      confidential_vm_enabled             = optional(bool)
      accelerated_network_support_enabled = optional(bool)
      tags                                = optional(map(string))
      image_version = optional(list(object({
        image_name       = string
        managed_image_id = optional(string)
        target_region = object({
          name                   = string
          regional_replica_count = string
          storage_account_type   = string
        })
      })))
    })
  )
  default = {}
}

variable "sharing" {
  type = object({ permission = string
    community_gallery = optional(object({ eula = string
      prefix          = string
      publisher_email = string
  publisher_uri = string })) })
  default = null
}

# Tags for resources
variable "tags" {
  type        = map(string)
  description = "(Optional) Tags to be applied to the resources."
  default     = null
}

variable "timeouts" {
  type = object({ create = optional(string)
    delete = optional(string)
    read   = optional(string)
  update = optional(string) })
  default = null
}