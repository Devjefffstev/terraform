variable "subscription_id" {
  type        = string
  description = "The Subscription ID to deploy resources to."

}
variable "location" {
  type        = string
  description = "(Required) The Azure Region where the Virtual Machine Scale Set should exist."
  default     = "East US"

}
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group in which to create the Virtual Machine Scale Set."
  default     = "rg-nomad-one-and-one"
}

variable "create_packer_image" {
  type        = bool
  description = "(Optional) Whether to always run packer to create a new image. Useful for testing."
  default     = false

}


variable "vmss_config_map" {
  description = "A map of VMSS configurations, each entry is an object with all VMSS variables."
  type = map(object({
    extension_protected_setting = optional(map(string), null)
    vmss_name                   = string
    location                    = string
    resource_group_name         = string
    user_data_base64            = optional(string, null)
    additional_capabilities = optional(object({
      ultra_ssd_enabled = optional(bool, null)
    }), null)
    admin_password = optional(string, null)
    admin_ssh_keys = optional(set(object({
      username   = string
      public_key = string
      id         = string
    })), null)
    automatic_instance_repair = optional(object({
      enabled      = bool
      grace_period = string
    }), null)
    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }), null)
    capacity_reservation_group_id = optional(string, null)
    data_disk = optional(set(object({
      caching                        = string
      create_option                  = optional(string)
      disk_encryption_set_id         = optional(string)
      disk_size_gb                   = optional(number)
      lun                            = optional(number)
      storage_account_type           = string
      ultra_ssd_disk_iops_read_write = optional(number)
      ultra_ssd_disk_mbps_read_write = optional(number)
      write_accelerator_enabled      = optional(bool)
    })), null)
    enable_telemetry           = optional(bool, null)
    encryption_at_host_enabled = optional(bool, null)
    eviction_policy            = optional(string, null)
    extension = optional(set(object({
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
    })), null)
    extension_operations_enabled = optional(bool, null)
    extensions_time_budget       = optional(string, null)
    instances                    = optional(number, null)
    license_type                 = optional(string, null)
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    managed_identities = optional(object({
      system_assigned            = optional(bool, false)
      user_assigned_resource_ids = optional(set(string), [])
    }), null)
    max_bid_price = optional(number, null)
    network_interface = optional(set(object({
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
    })), null)
    os_disk = optional(object({
      caching                   = string
      disk_encryption_set_id    = optional(string)
      disk_size_gb              = optional(number)
      storage_account_type      = string
      write_accelerator_enabled = optional(bool)
      diff_disk_settings = optional(object({
        option    = string
        placement = optional(string)
      }))
    }), null)
    os_profile = optional(any, null)
    plan = optional(object({
      name      = string
      publisher = string
      product   = string
    }), null)
    platform_fault_domain_count = optional(number, null)
    priority                    = optional(string, null)
    priority_mix = optional(object({
      regular_percentage = optional(number)
      spot_percentage    = optional(number)
    }), null)
    proximity_placement_group_id = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), null)
    single_placement_group = optional(bool, null)
    sku_name               = optional(string, null)
    source_image_id        = optional(any, null)
    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }), null)
    tags = optional(map(string), null)
    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string)
    }), null)
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }), null)
    upgrade_policy = optional(object({
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
    }), null)
    zone_balance        = optional(bool, null)
    zones               = optional(set(string), null)
    image_galleries     = optional(any, {})
    create_packer_image = optional(bool, null)
  }))
  default = {}
}