module "compute_gallery" {
  source              = "Azure/avm-res-compute-gallery/azurerm"
  for_each            = local.shared_image_galleries
  location            = each.value.location
  name                = each.key
  resource_group_name = each.value.resource_group_name
  # Optional
  shared_image_definitions = each.value.shared_image_definitions
  tags                     = each.value.tags
}

resource "azurerm_shared_image_version" "this" {
  for_each = local.images_def_id
  name                = "0.0.1"
  gallery_name        = each.value.gallery_name
  image_name          = each.value.image_name
  resource_group_name = each.value.resource_group_name
  location            = var.location
  managed_image_id    = each.value.image_id

  target_region {
    name                   = data.azurerm_shared_image.existing.location
    regional_replica_count = 5
    storage_account_type   = "Standard_LRS"
  }
}



module "nomad-server" {

  source                        = "Azure/avm-res-compute-virtualmachinescaleset/azurerm"
  location                      = var.location
  extension_protected_setting   = var.extension_protected_setting
  name                          = var.vmss_name
  resource_group_name           = var.resource_group_name
  user_data_base64              = var.user_data_base64
  additional_capabilities       = var.additional_capabilities
  admin_password                = var.admin_password
  admin_ssh_keys                = var.admin_ssh_keys
  automatic_instance_repair     = var.automatic_instance_repair
  boot_diagnostics              = var.boot_diagnostics
  capacity_reservation_group_id = var.capacity_reservation_group_id
  data_disk                     = var.data_disk

  enable_telemetry             = var.enable_telemetry
  encryption_at_host_enabled   = var.encryption_at_host_enabled
  eviction_policy              = var.eviction_policy
  extension                    = var.extension
  extension_operations_enabled = var.extension_operations_enabled
  extensions_time_budget       = var.extensions_time_budget
  instances                    = var.instances
  license_type                 = var.license_type
  lock                         = var.lock
  managed_identities           = var.managed_identities
  max_bid_price                = var.max_bid_price
  network_interface            = var.network_interface
  os_disk                      = var.os_disk
  os_profile                   = var.os_profile
  plan                         = var.plan
  platform_fault_domain_count  = var.platform_fault_domain_count
  priority                     = var.priority
  priority_mix                 = var.priority_mix
  proximity_placement_group_id = var.proximity_placement_group_id
  role_assignments             = var.role_assignments
  single_placement_group       = var.single_placement_group
  sku_name                     = var.sku_name
  source_image_id              = local.source_image_id
  source_image_reference       = var.source_image_reference
  tags                         = var.tags
  termination_notification     = var.termination_notification
  timeouts                     = var.timeouts
  upgrade_policy               = var.upgrade_policy
  zone_balance                 = var.zone_balance
  zones                        = var.zones

  depends_on = [module.compute_gallery]

}
