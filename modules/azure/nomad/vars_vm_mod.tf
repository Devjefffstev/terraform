variable "vm_mod_name" {
  type = string
}

variable "vm_mod_network_interfaces" {
  type = map(
    object({
      name               = string
      ip_configurations  = map(
        object({
          name                               = string
          app_gateway_backend_pools         = optional(
            map(
              object({
                app_gateway_backend_pool_resource_id = string
              })
            ),
            {}
          )
          create_public_ip_address           = optional(bool, false)
          gateway_load_balancer_frontend_ip_configuration_resource_id = optional(string)
          is_primary_ipconfiguration         = optional(bool, true)
          load_balancer_backend_pools        = optional(
            map(
              object({
                load_balancer_backend_pool_resource_id = string
              })
            ),
            {}
          )
          load_balancer_nat_rules            = optional(
            map(
              object({
                load_balancer_nat_rule_resource_id = string
              })
            ),
            {}
          )
          private_ip_address                 = optional(string)
          private_ip_address_allocation      = optional(string, "Dynamic")
          private_ip_address_version         = optional(string, "IPv4")
          private_ip_subnet_resource_id      = optional(string)
          public_ip_address_lock_name        = optional(string)
          public_ip_address_name             = optional(string)
          public_ip_address_resource_id      = optional(string)
        })
      )
      accelerated_networking_enabled = optional(bool, false)
      application_security_groups    = optional(
        map(
          object({
            application_security_group_resource_id = string
          })
        ),
        {}
      )
      diagnostic_settings           = optional(
        map(
          object({
            name                                 = optional(string, null)
            log_categories                       = optional(set(string), [])
            log_groups                           = optional(set(string), [])
            metric_categories                    = optional(set(string), ["AllMetrics"])
            log_analytics_destination_type      = optional(string, null)
            workspace_resource_id               = optional(string, null)
            storage_account_resource_id         = optional(string, null)
            event_hub_authorization_rule_resource_id = optional(string, null)
            event_hub_name                      = optional(string, null)
            marketplace_partner_resource_id     = optional(string, null)
          })
        ),
        {}
      )
      dns_servers                      = optional(list(string))
      inherit_tags                    = optional(bool, true)
      internal_dns_name_label          = optional(string)
      ip_forwarding_enabled            = optional(bool, false)
      is_primary                       = optional(bool, false)
      lock_level                       = optional(string)
      lock_name                        = optional(string)
      network_security_groups          = optional(
        map(
          object({
            network_security_group_resource_id = string
          })
        ),
        {}
      )
      resource_group_name              = optional(string)
      role_assignments                 = optional(
        map(
          object({
            principal_id                          = string
            role_definition_id_or_name           = string
            assign_to_child_public_ip_addresses  = optional(bool, true)
            condition                            = optional(string, null)
            condition_version                    = optional(string, null)
            delegated_managed_identity_resource_id = optional(string, null)
            description                          = optional(string, null)
            skip_service_principal_aad_check    = optional(bool, false)
            principal_type                       = optional(string, null)
          })
        ),
        {}
      )
      tags = optional(map(string), null)
    })
  ) 
}
variable "vm_mod_zone" {
  type = string
  description = "The Availability Zone which the Virtual Machine should be allocated in, only one zone would be accepted. If set then this module won't create `azurerm_availability_set` resource. Changing this forces a new resource to be created. This has been moved to a required value to comply with WAF guidance to intentionally select zones for resources as part of resource architectures. If deploying to a region without zones, set this value to null."
}

## Optional Inputs
## These variables have default values and don't have to be set to use this module. You may set these variables to override their default values.
variable "vm_mod_account_credentials" {
  type = object({
    admin_credentials = optional(
      object({
        username                          = optional(string, "azureuser")
        password                          = optional(string, null)
        ssh_keys                          = optional(list(string), [])
        generate_admin_password_or_ssh_key = optional(bool, true) # Use of flag is required to avoid known after apply issues
      }),
      {}
    )
    key_vault_configuration = optional(
      object({
        resource_id = string
        secret_configuration = optional(
          object({
            name                              = optional(string, null)
            expiration_date_length_in_days   = optional(number, 45)
            content_type                     = optional(string, "text/plain")
            not_before_date                  = optional(string, null)
            tags                             = optional(map(string), {})
          }),
          {}
        )
      }),
      null
    )
    password_authentication_disabled = optional(bool, true)

    # Future additional user credentials map?
  })
}

variable "vm_mod_additional_unattend_contents" {
  type = list(object({ content = string 
  setting = string }))
}

variable "vm_mod_allow_extension_operations" {
  type = bool
  default = true
}
variable "vm_mod_availability_set_resource_id" {
  type        = string
  description = <<EOT
(Optional) Specifies the Azure Resource ID of the Availability Set in which the Virtual Machine should exist. 
Cannot be used along with `new_availability_set`, `new_capacity_reservation_group`, 
`capacity_reservation_group_id`, `virtual_machine_scale_set_id`, `zone`.
Changing this forces a new resource to be created.
EOT
  default     = null
}

variable "vm_mod_azure_backup_configurations" {
  type = map(
    object({
      resource_group_name        = optional(string, null)
      recovery_vault_name        = optional(string, null)
      recovery_vault_resource_id = string
      backup_policy_resource_id  = optional(string, null)
      exclude_disk_luns          = optional(list(number), null)
      include_disk_luns          = optional(list(number), null)
    })
  )
  description = <<EOT
(Optional) Specifies the configuration details for Azure Backup. Each entry in the map corresponds to a specific configuration.
- `resource_group_name`: (Optional) The name of the resource group.
- `recovery_vault_name`: (Optional) The name of the recovery vault.
- `recovery_vault_resource_id` (Required): The Azure Resource ID of the recovery vault.
- `backup_policy_resource_id`: (Optional) The Azure Resource ID of the backup policy.
- `exclude_disk_luns`: (Optional) Disks to exclude, specified as a list of logical unit numbers (LUNs).
- `include_disk_luns`: (Optional) Disks to include, specified as a list of logical unit numbers (LUNs).
EOT
}

variable "vm_mod_boot_diagnostics" {
  type        = bool
  description = <<EOT
(Optional) Enable or Disable boot diagnostics.
EOT
  default = false
}

variable "vm_mod_boot_diagnostics_storage_account_uri" {
  type        = string
  description = <<EOT
(Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used 
to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. 
Passing a null value will utilize a managed storage account for diagnostics.
EOT
  default = null
}

variable "vm_mod_bypass_platform_safety_checks_on_user_schedule_enabled" {
  type        = bool
  description = <<EOT
(Optional) Specifies whether to skip platform scheduled patching when a user schedule 
is associated with the VM. This value can only be set to `true` when `patch_mode` is set to `AutomaticByPlatform`.
EOT
  default = false
}

variable "vm_mod_capacity_reservation_group_resource_id" {
  type        = string
  description = <<EOT
(Optional) Specifies the Azure Resource ID of the Capacity Reservation Group with the virtual machine 
should be allocated to. Cannot be used with `availability_set_id` or `proximity_placement_group_id`.
EOT
  default = null
}

variable "vm_mod_computer_name" {
  type        = string
  description = <<EOT
(Optional) Specifies the Hostname which should be used for this virtual machine. If unspecified, 
this defaults to the value for the `vm_name` field. If the value of the `vm_name` field is not a valid `computer_name`, 
then you must specify `computer_name`. Changing this forces a new resource to be created.
EOT
  default = null
}

variable "vm_mod_custom_data" {
  type        = string
  description = <<EOT
(Optional) The Base64 encoded Custom Data for building this virtual machine. Changing this forces a new resource to be created.
EOT
  default = null
}

variable "vm_mod_data_disk_managed_disks" {
  type = map(
    object({
      caching                                = string
      lun                                    = number
      name                                   = string
      storage_account_type                  = string
      create_option                         = optional(string, "Empty")
      disk_access_resource_id               = optional(string)
      disk_attachment_create_option         = optional(string)
      disk_encryption_set_resource_id       = optional(string) # this is currently a preview feature in the provider
      disk_iops_read_only                   = optional(number, null)
      disk_iops_read_write                  = optional(number, null)
      disk_mbps_read_only                   = optional(number, null)
      disk_mbps_read_write                  = optional(number, null)
      disk_size_gb                          = optional(number, 128)
      gallery_image_reference_resource_id   = optional(string)
      hyper_v_generation                    = optional(string)
      image_reference_resource_id           = optional(string)
      inherit_tags                          = optional(bool, true)
      lock_level                            = optional(string, null)
      lock_name                             = optional(string, null)
      logical_sector_size                   = optional(number, null)
      max_shares                            = optional(number)
      network_access_policy                 = optional(string)
      on_demand_bursting_enabled            = optional(bool)
      optimized_frequent_attach_enabled     = optional(bool, false)
      os_type                               = optional(string)
      performance_plus_enabled              = optional(bool, false)
      public_network_access_enabled         = optional(bool)
      resource_group_name                   = optional(string)
      secure_vm_disk_encryption_set_resource_id = optional(string)
      security_type                         = optional(string)
      source_resource_id                    = optional(string)
      source_uri                            = optional(string)
      storage_account_resource_id           = optional(string)
      tags                                  = optional(map(string), null)
      tier                                  = optional(string)
      trusted_launch_enabled                = optional(bool)
      upload_size_bytes                     = optional(number, null)
      write_accelerator_enabled             = optional(bool)
      encryption_settings                   = optional(
        list(
          object({
            disk_encryption_key_vault_secret_url = optional(string)
            disk_encryption_key_vault_resource_id = optional(string)
            key_encryption_key_vault_secret_url   = optional(string)
            key_encryption_key_vault_resource_id  = optional(string)
          })
        ),
        []
      )
      role_assignments = optional(
        map(
          object({
            role_definition_id_or_name           = string
            principal_id                          = string
            description                           = optional(string, null)
            skip_service_principal_aad_check      = optional(bool, false)
            condition                             = optional(string, null)
            condition_version                     = optional(string, null)
            delegated_managed_identity_resource_id = optional(string, null)
            principal_type                        = optional(string, null)
          })
        ),
        {}
      )
    })
  )
  description = <<EOT
(Optional) A map of managed disk configurations. Each configuration includes details for a managed disk 
attached to the VM. Changing properties may require a new resource to be created. Includes options for encryption, IOPS, tiering, and attachment specifics.
EOT
default = {}
}

variable "vm_mod_dedicated_host_group_resource_id" {
  type        = string
  description = <<EOT
(Optional) The Azure Resource ID of the dedicated host group where this virtual machine should run.
Conflicts with dedicated_host_resource_id (dedicated_host_group_id on the azurerm provider).
EOT
  default = null
}

variable "vm_mod_dedicated_host_resource_id" {
  type        = string
  description = <<EOT
(Optional) The Azure Resource ID of the dedicated host where this virtual machine should run.
Conflicts with dedicated_host_group_resource_id (dedicated_host_group_id on the azurerm provider).
EOT
  default = null
}

variable "vm_mod_diagnostic_settings" {
  type = map(
    object({
      name                                     = optional(string, null)
      log_categories                          = optional(set(string), [])
      log_groups                              = optional(set(string), [])
      metric_categories                       = optional(set(string), ["AllMetrics"])
      log_analytics_destination_type          = optional(string, "Dedicated")
      workspace_resource_id                   = optional(string, null)
      storage_account_resource_id             = optional(string, null)
      event_hub_authorization_rule_resource_id = optional(string, null)
      event_hub_name                          = optional(string, null)
      marketplace_partner_resource_id         = optional(string, null)
    })
  )
  description = <<EOT
This map object is used to define the diagnostic settings on the virtual machine. This functionality does not implement the diagnostic settings extension,
but instead can be used to configure sending the VM metrics to one of the standard targets.

Example Input:
diagnostic_settings = {
  vm_diags = {
    name                 = "monitor_diagnostic_setting"
    workspace_resource_id = azurerm_log_analytics_workspace.this_workspace.id
    metric_categories    = ["AllMetrics"]
  }
}
EOT
  default = {}
}

variable "vm_mod_disable_password_authentication" {
  type        = bool
  description = <<EOT
DEPRECATED: This input has been moved to `account_credentials.password_authentication_disabled`
and will be removed with the release of version v1.0.0. If true, this value will disallow password 
authentication on Linux VMs. At least one public key must be configured.
EOT
  default = true
}

variable "vm_mod_disk_controller_type" {
  type        = string
  description = <<EOT
(Optional) Specifies the Disk Controller Type used for this Virtual Machine. Possible values are `SCSI` and `NVME`.
EOT
  default = null
}

variable "vm_mod_edge_zone" {
  type        = string
  description = <<EOT
(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Machine should exist.
Changing this forces a new Virtual Machine to be created.
EOT
  default = null
}

variable "vm_mod_enable_automatic_updates" {
  type        = bool
  description = <<EOT
(Optional) Specifies if Automatic Updates are enabled for the Windows Virtual Machine.
Changing this forces a new resource to be created.
EOT
  default = true
}

variable "vm_mod_enable_telemetry" {
  type        = bool
  description = <<EOT
This variable controls whether or not telemetry is enabled for the module.
For more information, see https://aka.ms/avm/telemetry. Setting this to `false`
ensures no telemetry data is collected.
EOT
  default = true
}

variable "vm_mod_encryption_at_host_enabled" {
  type        = bool
  description = <<EOT
(Optional) Should all of the disks (including the temp disk) attached to this Virtual Machine
be encrypted by enabling Encryption at Host?
EOT
  default = true
}

variable "vm_mod_extensions" {
  type = map(
    object({
      name                = string
      publisher           = string
      type                = string
      type_handler_version = string
      auto_upgrade_minor_version = optional(bool)
      automatic_upgrade_enabled  = optional(bool)
      deploy_sequence            = optional(number, 5)
      failure_suppression_enabled = optional(bool, false)
      settings                   = optional(string)
      protected_settings         = optional(string)
      provision_after_extensions = optional(list(string), [])
      tags                       = optional(map(string), null)
      protected_settings_from_key_vault = optional(
        object({
          secret_url    = string
          source_vault_id = string
        })
      )
      timeouts = optional(
        object({
          create = optional(string)
          delete = optional(string)
          update = optional(string)
          read   = optional(string)
        })
      )
    })
  )
  description = <<EOT
This map of objects is used to create additional `azurerm_virtual_machine_extension` resources, with configurations
such as script execution, tags, and timeouts. Refer to the Azure resource docs for additional extension details.
EOT
  default = {}
}
variable "vm_mod_extensions_time_budget" {
  type        = string
  description = <<EOT
(Optional) Specifies the duration allocated for all extensions to start. 
The time duration should be between 15 minutes and 120 minutes (inclusive) and should be specified in ISO 8601 format.
EOT
  default = "PT1H30M"
}

variable "vm_mod_gallery_applications" {
  type = map(
    object({
      version_id           = string
      configuration_blob_uri = optional(string)
      order                = optional(number, 0)
      tag                  = optional(string)
    })
  )
  description = <<EOT
A map of gallery application objects with the following elements:
- `<map key>` - Used to designate a unique instance for a gallery application.
- `version_id` (Required) Specifies the Gallery Application Version resource ID.
- `configuration_blob_uri` (Optional) Specifies the URI to an Azure Blob that will replace the default configuration for the package if provided.
- `order` (Optional) Specifies the order in which the packages need to be installed.
- `tag` (Optional) A passthrough value for generic context.

Example:
gallery_applications = {
  application_1 = {
    version_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Compute/galleries/{galleryName}/applications/{applicationName}/versions/{version}"
    order = 1
  }
}
EOT
  default = {}
}

variable "vm_mod_generate_admin_password_or_ssh_key" {
  type        = bool
  description = <<EOT
DEPRECATED: The logic behind this input has been moved to `account_credentials`.
This input will be removed with the release of version v1.0.0.
If `os_type` is Linux, this will generate and store an SSH key as the default.
Setting `disable_password_authentication` to `false` will generate and store a password instead of an SSH key.
EOT
  default = true
}

variable "vm_mod_generated_secrets_key_vault_secret_config" {
  type = object({
    key_vault_resource_id       = string
    name                        = optional(string, null)
    expiration_date_length_in_days = optional(number, 45)
    content_type                = optional(string, "text/plain")
    not_before_date             = optional(string, null)
    tags                        = optional(map(string), {})
  })
  description = <<EOT
DEPRECATED: The logic behind this input has been consolidated to `account_credentials.key_vault_configuration`.
For simplicity, this variable provides the option to store an auto-generated admin user password or SSH key in a key vault.
The object includes:
- `name` (Optional): Name used for the key vault secret storing the SSH key or password.
- `expiration_date_length_in_days` (Optional): Number of days from installation to expiration. Defaults to 45 days.
- `content_type` (Optional): The secret content type. Defaults to `text/plain`.
- `not_before_date` (Optional): UTC datetime indicating when the secret becomes valid. Defaults to null.
EOT
  default = null
}

variable "vm_mod_hotpatching_enabled" {
  type        = bool
  description = <<EOT
(Optional) Should the VM be patched without requiring a reboot?
Hotpatching can only be enabled if the `patch_mode` is set to `AutomaticByPlatform` and the VM meets other prerequisites.
EOT
  default = false
}

variable "vm_mod_license_type" {
  type        = string
  description = <<EOT
(Optional) Specifies the license type for the virtual machine:
- Valid options for Linux: `RHEL_BYOS`, `SLES_BYOS`.
- Valid options for Windows: `None`, `Windows_Client`, `Windows_Server`.
EOT
  default = null
}

variable "vm_mod_lock" {
  type = object({
    name = optional(string, null)
    kind = string
  })
  description = <<EOT
(Optional) Specifies the lock configuration for this virtual machine and child resources:
- `kind` (Required): Type of lock (`CanNotDelete` or `ReadOnly`).
- `name` (Optional): Name of the lock. If unset, defaults to a generated name based on the `kind`.

Example:
lock = {
  kind = "CanNotDelete"
  name = "lock-resourcename"
}
EOT
  default = null
}

variable "vm_mod_maintenance_configuration_resource_ids" {
  type = map(string)
  description = <<EOT
A map of maintenance configuration IDs to apply to this virtual machine. Key-value pairs allow indexing by arbitrary keys.
Example Input:
maintenance_configuration_resource_ids = {
  config_1 = "<maintenance_config_resource_id>"
}
EOT
  default = {}
}

variable "vm_mod_managed_identities" {
  type = object({
    system_assigned          = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  description = <<EOT
Specifies managed identities for the virtual machine:
- `system_assigned` (Optional): Whether a system-assigned identity should be enabled. Defaults to `false`.
- `user_assigned_resource_ids` (Optional): List of user-assigned identity resource IDs.
EOT
  default = {}
}

variable "vm_mod_max_bid_price" {
  type        = number
  description = <<EOT
(Optional) The maximum price you're willing to pay for a Spot VM, in USD. Defaults to `-1` to prevent eviction for price reasons.
EOT
  default = -1
}

variable "vm_mod_os_disk" {
  type = object({
    caching                   = string
    storage_account_type      = string
    disk_encryption_set_id    = optional(string)
    disk_size_gb              = optional(number, null)
    name                      = optional(string, null)
    secure_vm_disk_encryption_set_id = optional(string)
    security_encryption_type  = optional(string)
    write_accelerator_enabled = optional(bool, false)
    diff_disk_settings = optional(
      object({
        option    = string
        placement = optional(string, "CacheDisk")
      }),
      null
    )
  })
  description = <<EOT
Configuration values for the OS disk of the virtual machine:
- `caching` (Required): Type of caching used (`None`, `ReadOnly`, `ReadWrite`).
- `storage_account_type` (Required): Type of backing storage (`Standard_LRS`, `Premium_LRS`, `StandardSSD_ZRS`, etc.).
- `disk_encryption_set_id` (Optional): Azure resource ID of the Disk Encryption Set.
- `disk_size_gb` (Optional): Override from the default size. Defaults to null.
- Includes optional diff disk settings.
EOT
  default = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}

variable "vm_mod_os_type" {
  type        = string
  description = <<EOT
The base OS type used to build the VM. Valid options: `Windows`, `Linux`.
EOT
  default = "Windows"
}

variable "vm_mod_patch_assessment_mode" {
  type        = string
  description = <<EOT
(Optional) Specifies the mode of VM Guest Patching for the Virtual Machine. 
Possible values are `AutomaticByPlatform` or `ImageDefault`.
EOT
  default = "ImageDefault"
}

variable "vm_mod_patch_mode" {
  type        = string
  description = <<EOT
(Optional) Specifies the mode of in-guest patching for this Linux Virtual Machine. 
Possible values are `AutomaticByPlatform` and `ImageDefault`. 
For more information on patch modes, refer to the product documentation.
EOT
  default = null
}

variable "vm_mod_plan" {
  type = object({
    name      = string
    product   = string
    publisher = string
  })
  description = <<EOT
An object variable that defines the Marketplace image this virtual machine should be created from:
- `name` (Required): Name of the Marketplace Image the VM is created from.
- `product` (Required): Product of the Marketplace Image.
- `publisher` (Required): Publisher of the Marketplace Image.

Example:
plan = {
  name      = "17_04_02-payg-essentials"
  product   = "cisco-8000v"
  publisher = "cisco"
}
EOT
  default = null
}

variable "vm_mod_platform_fault_domain" {
  type        = number
  description = <<EOT
(Optional) Specifies the Platform Fault Domain for the VM. Defaults to `null`, enabling automatic assignment 
to a fault domain that balances across the available domains. `virtual_machine_scale_set_id` is required.
EOT
  default = null
}

variable "vm_mod_priority" {
  type        = string
  description = <<EOT
(Optional) Specifies the priority of the Virtual Machine. 
Possible values are `Regular` and `Spot`. Defaults to `Regular`.
EOT
  default = "Regular"
}

variable "vm_mod_provision_vm_agent" {
  type        = bool
  description = <<EOT
(Optional) Specifies whether to provision the Azure VM Agent on this Virtual Machine. 
Defaults to `true`. If set to `false`, `allow_extension_operations` must also be set to `false`.
EOT
  default = true
}

variable "vm_mod_proximity_placement_group_resource_id" {
  type        = string
  description = <<EOT
(Optional) Specifies the ID of the Proximity Placement Group assigned to this Virtual Machine. 
Conflicts with `capacity_reservation_group_resource_id`.
EOT
  default = null
}

variable "vm_mod_public_ip_configuration_details" {
  type = object({
    allocation_method                = optional(string, "Static")
    ddos_protection_mode             = optional(string, "VirtualNetworkInherited")
    ddos_protection_plan_id          = optional(string)
    domain_name_label                = optional(string)
    idle_timeout_in_minutes          = optional(number, 30)
    inherit_tags                     = optional(bool, false)
    ip_version                       = optional(string, "IPv4")
    lock_level                       = optional(string, null)
    sku                              = optional(string, "Standard")
    sku_tier                         = optional(string, "Regional")
    tags                             = optional(map(string), null)
    zones                            = optional(set(string), ["1", "2", "3"])
  })
  description = <<EOT
This object describes the Public IP configuration for VMs:
- `allocation_method`: (Required) Static/Dynamic allocation of the IP.
- `ddos_protection_mode`: (Optional) DDoS Protection modes. Possible values: Disabled, Enabled, VirtualNetworkInherited.
- `idle_timeout_in_minutes`: (Optional) TCP idle connection timeout. Range: 4—30 minutes.
- `zones`: (Optional) Zones to assign the public IP. Defaults to all zones.
Example:
public_ip_configuration_details = {
  allocation_method = "Static"
  ddos_protection_mode = "VirtualNetworkInherited"
  idle_timeout_in_minutes = 30
  ip_version = "IPv4"
  sku_tier = "Regional"
  sku = "Standard"
}
EOT
  default = {
    allocation_method       = "Static"
    ddos_protection_mode    = "VirtualNetworkInherited"
    idle_timeout_in_minutes = 30
    ip_version              = "IPv4"
    sku                     = "Standard"
    sku_tier                = "Regional"
  }
}

variable "vm_mod_reboot_setting" {
  type        = string
  description = <<EOT
(Optional) Specifies the reboot setting for platform scheduled patching. 
Possible values: `Always`, `IfRequired`, `Never`. Requires `patch_mode` set to `AutomaticByPlatform`.
EOT
  default = null
}

variable "vm_mod_role_assignments" {
  type = map(
    object({
      role_definition_id_or_name           = string
      principal_id                          = string
      condition                             = optional(string, null)
      condition_version                     = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      description                           = optional(string, null)
      principal_type                        = optional(string, null)
      skip_service_principal_aad_check      = optional(bool, false)
    })
  )
  description = <<EOT
Maps Role Definitions/Scopes assigned as part of the VM resource.
- `role_definition_id_or_name`: (Optional) Role assigned, e.g., `Storage Blob Data Contributor`.
- `principal_id`: (Optional) ID for Principal (User, Group, or Service Principal).
Example:
role_assignments = {
  assignment_1 = {
    role_definition_id_or_name = "Storage Blob Data Contributor"
    principal_id = data.azuread_client_config.current.object_id
  }
}
EOT
  default = {}
}

variable "vm_mod_role_assignments_system_managed_identity" {
  type = map(
    object({
      role_definition_id_or_name = string
      scope_resource_id          = string
      condition                  = optional(string, null)
      condition_version          = optional(string, null)
      description                = optional(string, null)
      skip_service_principal_aad_check = optional(bool, false)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type             = optional(string, null)
    })
  )
  description = <<EOT
Maps Role Definitions assigned to external scopes using System Managed Identity:
- `scope_resource_id`: Required scope ID, e.g., Azure Resource Group.
Example:
role_assignments_system_managed_identity = {
  assignment_1 = {
    scope_resource_id = "/subscriptions/000000-000/resourceGroups/example/providers/Microsoft.Storage/storageAccounts/abc"
    role_definition_id_or_name = "Storage Blob Data Contributor"
  }
}
EOT
  default = {}
}

variable "vm_mod_run_commands" {
  type = map(
    object({
      location                 = string
      name                     = string
      deploy_sequence          = optional(number, 3)
      script_source            = object({
        command_id             = optional(string)
        script                 = optional(string)
        script_uri             = optional(string)
        script_uri_managed_identity = optional(object({
          client_id            = optional(string)
          object_id            = optional(string)
        }))
      })
      error_blob_managed_identity = optional(object({
        client_id              = optional(string)
        object_id              = optional(string)
      }))
      error_blob_uri           = optional(string)
      output_blob_managed_identity = optional(object({
        client_id              = optional(string)
        object_id              = optional(string)
      }))
      output_blob_uri          = optional(string)
      parameters               = optional(map(object({
        name                   = string
        value                  = string
      })), {})
      tags                     = optional(map(string))
    })
  )
  description = <<EOT
      Use this variable to configure VM Run Commands. Each command must include:
      - `location`: Azure Region.
      - `name`: Name of Run Command.

      Example:
      run_commands = {
        run_command_1 = {
          location = "eastus"
          name     = "Custom Script Extension"
        }
      }
      EOT
  default = {}
}

variable "vm_mod_run_commands_secrets" {
  type = map(
    object({
      protected_parameters = optional(map(object({
        name  = string
        value = string
      })), {})
      run_as_password      = optional(string)
      run_as_user          = optional(string)
    })
  )
  description = <<EOT
Defines sensitive values for VM Run Commands:
- `run_as_user`: (Optional) Name of account for running command.
- `parameters`: (Optional) Key-value pairs of protected params.
EOT
  default = {}
}

variable "vm_mod_secrets" {
  type = list(
    object({
      key_vault_id = string
      certificate = set(
        object({
          url   = string
          store = optional(string)
        })
      )
    })
  )
  description = <<EOT
A list of objects defining VM secrets, specifying the Key Vault and certificates used:
- `key_vault_id` (Required): The Key Vault ID to source secrets from.
- `certificate` (Required): Certificates as a set of objects:
  - `url` (Required): Key Vault Secret URL.
  - `store` (Optional): Certificate store (e.g., "My" for Windows).

Example:
secrets = [
  {
    key_vault_id = azurerm_key_vault.example.id
    certificate = [
      {
        url   = azurerm_key_vault_certificate.example.secret_id
        store = "My"
      }
    ]
  }
]
EOT
  default = []
}

variable "vm_mod_secure_boot_enabled" {
  type        = bool
  description = <<EOT
(Optional) Specifies whether Secure Boot should be enabled on the virtual machine. 
Changing this forces a new resource to be created.
EOT
  default = null
}

variable "vm_mod_shutdown_schedules" {
  type = map(
    object({
      daily_recurrence_time = string
      notification_settings = optional(
        object({
          enabled        = optional(bool, false)
          email          = optional(string, null)
          time_in_minutes = optional(string, "30")
          webhook_url    = optional(string, null)
        }),
        {
          enabled = false
        }
      )
      timezone = string
      enabled  = optional(bool, true)
      tags     = optional(map(string), null)
    })
  )
  description = <<EOT
Defines an auto-shutdown schedule for the virtual machine:
- `daily_recurrence_time`: (Required) Time each day (HHmm) when the schedule takes effect.
- `notification_settings`: (Optional). Includes settings for notifications like webhook or email before shutdown.
- `timezone`: (Required) Timezone for the schedule.

Example:
shutdown_schedules = {
  my_schedule = {
    daily_recurrence_time = "1800"
    timezone             = "Pacific Standard Time"
    enabled              = true
    notification_settings = {
      enabled = true
      email   = "example@example.com"
    }
  }
}
EOT
  default = {}
}

variable "vm_mod_sku_size" {
  type        = string
  description = <<EOT
The SKU value to use for the deployment of this virtual machine, e.g., "Standard_D2s_v3".
EOT
  default = "Standard_D2ds_v5"
}

variable "vm_mod_source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = <<EOT
The source image to use for building the VM:
- `publisher`: The publisher of the image (e.g., "MicrosoftWindowsServer").
- `offer`: The offer of the image.
- `sku`: The SKU of the image.
- `version`: Version of the image (e.g., "latest").

Example:
source_image_reference = {
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "20_04-lts"
  version   = "latest"
}
EOT
  default = {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

variable "vm_mod_source_image_resource_id" {
  type        = string
  description = <<EOT
The Azure Resource ID of a custom source image to create the VM.
Either `source_image_resource_id` or `source_image_reference` must be set, but not both.
EOT
  default = null
}

variable "vm_mod_tags" {
  type        = map(string)
  description = <<EOT
Map of tags to be assigned to the virtual machine resource.
EOT
  default = {}
}

variable "vm_mod_termination_notification" {
  type = object({
    enabled = optional(bool, false)
    timeout = optional(string, "PT5M")
  })
  description = <<EOT
(Optional) Configuration for VM termination notification:
- `enabled`: Indicates whether termination notifications are enabled. Default: false.
- `timeout`: Duration (Iso8601 format) before the VM is terminated. Default: "PT5M".

Example:
termination_notification = {
  enabled = true
  timeout = "PT10M"
}
EOT
  default = null
}

variable "vm_mod_timeouts" {
  type = object({
    azurerm_virtual_machine_extension = optional(
      object({
        create = optional(string, "30m")
        delete = optional(string, "30m")
        update = optional(string, "30m")
        read   = optional(string, "5m")
      }),
      {}
    )
    azurerm_virtual_machine_run_command = optional(
      object({
        create = optional(string, "30m")
        delete = optional(string, "30m")
        update = optional(string, "30m")
        read   = optional(string, "5m")
      }),
      {}
    )
  })
  description = <<EOT
Specifies custom timeout configurations for VM-related resources:
- `azurerm_virtual_machine_extension`: Timeout for extensions.
- `azurerm_virtual_machine_run_command`: Timeout for VM commands.
EOT
  default = {}
}

variable "vm_mod_timezone" {
  type        = string
  description = <<EOT
(Optional) Specifies the timezone to be used by the virtual machine. 
Example: "Pacific Standard Time". Refer to supported timezones for valid values.
EOT
  default = null
}

variable "vm_mod_user_data" {
  type        = string
  description = <<EOT
(Optional) Base64-encoded custom user data for the virtual machine.
EOT
  default = null
}

variable "vm_mod_virtual_machine_scale_set_resource_id" {
  type        = string
  description = <<EOT
(Optional) Resource ID of the VM Scale Set within which this VM will be created. 
Conflicts with `availability_set_id`.
EOT
  default = null
}

variable "vm_mod_vm_additional_capabilities" {
  type = object({
    ultra_ssd_enabled    = optional(bool, false)
    hibernation_enabled  = optional(bool, null)
  })
  description = <<EOT
Configures additional VM capabilities:
- `ultra_ssd_enabled`: (Optional) Use UltraSSD storage (Default: false).
- `hibernation_enabled`: (Optional) Enable the hibernation capability.

Example:
vm_additional_capabilities = {
  ultra_ssd_enabled = true
}
EOT
  default = null
}

variable "vm_mod_vtpm_enabled" {
  type        = bool
  description = <<EOT
(Optional) Specifies whether vTPM should be enabled for the virtual machine.
Changing this forces a new resource to be created.
EOT
  default = null
}

variable "vm_mod_winrm_listeners" {
  type = set(
    object({
      protocol        = string
      certificate_url = optional(string)
    })
  )
  description = <<EOT
Defines WinRM listener configuration for Windows VMs:
- `protocol`: (Required) Either "Http" or "Https".
- `certificate_url` (Optional): URL to a Key Vault certificate. Required for "Https".

Example for HTTP:
winrm_listeners = [
  {
    protocol = "Http"
  }
]

Example for HTTPS:
winrm_listeners = [
  {
    protocol        = "Https"
    certificate_url = "https://example.vault.azure.net/certificates/example-cert"
  }
]
EOT
  default = []
}