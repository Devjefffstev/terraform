variable "extension_protected_setting" {
  type        = map(string)
  description = "(Optional) A JSON String which specifies Sensitive Settings (such as Passwords) for the Extension."
  default     = {}
}
variable "vmss_name" {
  type        = string
  description = "(Required) The name of the Virtual Machine Scale Set."
  default     = "vmss-nomad"

}
variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Virtual Machine Scale Set should exist."
  default     = "East US"

}
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group in which to create the Virtual Machine Scale Set."

}
variable "user_data_base64" {
  type        = string
  description = "(Optional) The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set."
  default     = null
}
variable "additional_capabilities" {
  type = object({
    ultra_ssd_enabled = optional(bool)
  })
  default = null
}

variable "admin_password" {
  type        = string
  description = "(Optional) The admin password for the Virtual Machine Scale Set. Changing this forces a new resource to be created."
  default     = null

}
variable "admin_ssh_keys" {
  type = set(object({
    username   = string
    public_key = string
    id         = string
  }))
  description = "(Optional) One or more SSH public keys associated with the user accounts of the Virtual Machine Scale Set."
  default     = null

}
variable "automatic_instance_repair" {
  type = object({
    enabled      = bool
    grace_period = string
  })
  description = "(Optional) The automatic instance repair policy of the Virtual Machine Scale Set."
  default = {
    "enabled" : true,
    "grace_period" : "PT30M"
  }

}
variable "boot_diagnostics" {
  type = object({
    storage_account_uri = optional(string)
  })
  description = "(Optional) The boot diagnostics of the Virtual Machine Scale Set."
  default     = null

}
variable "capacity_reservation_group_id" {
  type        = string
  description = "(Optional) The ID of the Capacity Reservation Group to associate with the Virtual Machine Scale Set."
  default     = null

}
variable "data_disk" {
  type = set(object({
    caching                        = string
    create_option                  = optional(string)
    disk_encryption_set_id         = optional(string)
    disk_size_gb                   = optional(number)
    lun                            = optional(number)
    storage_account_type           = string
    ultra_ssd_disk_iops_read_write = optional(number)
    ultra_ssd_disk_mbps_read_write = optional(number)
    write_accelerator_enabled      = optional(bool)
  }))
  default = null
}
variable "enable_telemetry" {
  type        = bool
  description = "(Optional) Should the Virtual Machine Scale Set send telemetry data to Microsoft?"
  default     = false

}
variable "encryption_at_host_enabled" {
  type        = bool
  description = "(Optional) Should the Virtual Machine Scale Set have Encryption at Host enabled?"
  default     = false

}
variable "eviction_policy" {
  type        = string
  description = "(Optional) The eviction policy for the Virtual Machine Scale Set. Possible values are: 'Deallocate' and 'Delete'."
  default     = null

}
variable "extension" {
  type = set(object({
    auto_upgrade_minor_version_enabled        = optional(bool)
    extensions_to_provision_after_vm_creation = optional(set(string))
    failure_suppression_enabled               = optional(bool)
    force_extension_execution_on_change       = optional(string)
    name                                      = string
    publisher                                 = string
    settings                                  = optional(string)
    type                                      = string
    type_handler_version                      = string
    protected_settings_from_key_vault = optional(object({
      secret_url      = string
      source_vault_id = string
    }), null)
  }))
  description = "(Optional) One or more extensions to add to the Virtual Machine Scale Set."
  default     = null

}
variable "extension_operations_enabled" {
  type        = bool
  description = "(Optional) Should extension operations be enabled for the Virtual Machine Scale Set?"
  default     = true

}
variable "extensions_time_budget" {
  type        = string
  description = "(Optional) The time budget for all extensions to be provisioned on the Virtual Machine Scale Set."
  default     = null
}
variable "instances" {
  type        = number
  description = "(Optional) The number of instances which should exist within the Virtual Machine Scale Set."
  default     = 2
}
variable "license_type" {
  type        = string
  description = "(Optional) Specifies that the image used was licensed on-premises. This element is only used for images that contain Windows Server."
  default     = null

}
variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null

}
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default = {}

}
variable "max_bid_price" {
  type        = number
  description = "(Optional) The maximum price you are willing to pay for a Spot VM in the Virtual Machine Scale Set. A value of -1 indicates that you are willing to pay the full price."
  default     = -1

}
variable "network_interface" {
  type = set(object({
    dns_servers                   = optional(set(string))
    enable_accelerated_networking = optional(bool)
    enable_ip_forwarding          = optional(bool)
    name                          = string
    network_security_group_id     = optional(string)
    primary                       = optional(bool)
    ip_configuration = set(object({
      application_gateway_backend_address_pool_ids = optional(set(string))
      application_security_group_ids               = optional(set(string))
      load_balancer_backend_address_pool_ids       = optional(set(string))
      name                                         = string
      primary                                      = optional(bool)
      subnet_id                                    = optional(string)
      version                                      = optional(string)
      public_ip_address = optional(set(object({
        domain_name_label       = optional(string)
        idle_timeout_in_minutes = optional(number)
        name                    = string
        public_ip_prefix_id     = optional(string)
        sku_name                = optional(string)
        version                 = optional(string)
        ip_tag = optional(set(object({
          tag  = string
          type = string
        })))
      })))
    }))
  }))
  description = "(Optional) One or more network interfaces to associate with the Virtual Machine Scale Set."
  default     = null
}
variable "os_disk" {
  type = object({
    caching                   = string
    disk_encryption_set_id    = optional(string)
    disk_size_gb              = optional(number)
    storage_account_type      = string
    write_accelerator_enabled = optional(bool)
    diff_disk_settings = optional(object({
      option    = string
      placement = optional(string)
    }))
  })
  description = "(Optional) The OS Disk which should be used for the Virtual Machine Scale Set."
  default = {
    "caching" : "ReadWrite",
    "storage_account_type" : "Premium_LRS"
  }

}
variable "os_profile" {
  type = object({
    custom_data = optional(string)
    linux_configuration = optional(object({
      admin_username                  = string
      computer_name_prefix            = optional(string)
      disable_password_authentication = optional(bool)
      patch_assessment_mode           = optional(string)
      patch_mode                      = optional(string, "AutomaticByPlatform")
      provision_vm_agent              = optional(bool, true)
      admin_ssh_key_id                = optional(set(string))
      secret = optional(set(object({
        key_vault_id = string
        certificate = set(object({
          url = string
        }))
      })))
    }))
    windows_configuration = optional(object({
      admin_username           = string
      computer_name_prefix     = optional(string)
      enable_automatic_updates = optional(bool, false)
      hotpatching_enabled      = optional(bool)
      patch_assessment_mode    = optional(string)
      patch_mode               = optional(string, "AutomaticByPlatform")
      provision_vm_agent       = optional(bool, true)
      timezone                 = optional(string)
      secret = optional(set(object({
        key_vault_id = string
        certificate = set(object({
          store = string
          url   = string
        }))
      })))
      winrm_listener = optional(set(object({
        certificate_url = optional(string)
        protocol        = string
      })))
    }))
  })
  description = "(Optional) The OS Profile which should be used for the Virtual Machine Scale Set."
  default     = null

}
variable "plan" {
  type = object({
    name      = string
    publisher = string
    product   = string
  })
  description = "(Optional) The plan which should be used for the Virtual Machine Scale Set."
  default     = null

}
variable "platform_fault_domain_count" {
  type        = number
  description = "(Optional) The platform fault domain count for the Virtual Machine Scale Set. Must be between 1 and 3."
  default     = 1

}
variable "priority" {
  type        = string
  description = "(Optional) The priority of the Virtual Machine Scale Set. Possible values are: 'Regular', 'Spot' and 'Low'."
  default     = "Regular"

}
variable "priority_mix" {
  type = object({
    regular_percentage = optional(number)
    spot_percentage    = optional(number)
  })
  description = "(Optional) The priority mix settings for the Virtual Machine Scale Set. Required if priority is set to 'Low'."
  default     = null

}
variable "proximity_placement_group_id" {
  type        = string
  description = "(Optional) The ID of the Proximity Placement Group to associate with the Virtual Machine Scale Set."
  default     = null

}
variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default = null

}
variable "single_placement_group" {
  type        = bool
  description = "(Optional) Should the Virtual Machine Scale Set be a single placement group?"
  default     = null

}
variable "sku_name" {
  type        = string
  description = "(Required) The SKU name which should be used for the Virtual Machine Scale Set."
  default     = "Standard_B1s"

}
variable "source_image_id" {
  type        = any
  description = <<EOF
It can be either:

  - (Optional) The ID of an Image which each Virtual Machine in this Scale Set should be based on. Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version IDs..
  - If it is not defined, it will create an Azure Image Gallery and take the latest version of the image from a Shared Image Gallery. That means this variable triggers the creation of a Shared Image Gallery. You must provide the values for `image_galleries` variable.
  

EOF
  default     = null
}
variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "(Optional) The Source Image Reference which should be used for the Virtual Machine Scale Set. Required if source_image_id is not provided."
  default     = null

}
variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags which should be assigned to the Virtual Machine Scale Set."
  default     = {}

}
variable "termination_notification" {
  type = object({
    enabled = bool
    timeout = optional(string)
  })

  default = null

}

variable "timeouts" {
  type = object({
    create = optional(string)
    delete = optional(string)
    read   = optional(string)
    update = optional(string)
  })
  description = "(Optional) Timeouts for create, read, update and delete operations."
  default     = null

}
variable "upgrade_policy" {
  type = object({
    upgrade_mode = optional(string, "Manual")
    rolling_upgrade_policy = optional(object({
      cross_zone_upgrades_enabled             = optional(bool)
      max_batch_instance_percent              = optional(number)
      max_unhealthy_instance_percent          = optional(number)
      max_unhealthy_upgraded_instance_percent = optional(number)
      pause_time_between_batches              = optional(string)
      prioritize_unhealthy_instances_enabled  = optional(bool)
      maximum_surge_instances_enabled         = optional(bool)
    }), {})
  })
  default = {
    "upgrade_mode" : "Manual"
  }

}
variable "zone_balance" {
  type        = bool
  description = "(Optional) Should the Virtual Machine Scale Set have zone balance enabled?"
  default     = false

}
variable "zones" {
  type        = set(string)
  description = "(Optional) A list of availability zones to be used for the Virtual Machine Scale Set."
  default = [
    "1",
    "2",
    "3"
  ]

}

variable "image_galleries" {
  type = map(object({
    location            = optional(string)
    resource_group_name = optional(string)
    shared_image_definitions = list(object({
      identifier = object({
        publisher = string
        offer     = string
      sku = string })
      os_type = string
      purchase_plan = optional(object({
        name      = string
        publisher = optional(string)
      product = optional(string) }))
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
  })) }))
  description = "Properties for VMSS Image Gallery"
  default     = {}

}