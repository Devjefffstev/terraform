module "compute_gallery" {
  source              = "Azure/avm-res-compute-gallery/azurerm"
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  # Optional variables
  shared_image_definitions = var.shared_image_definitions
  enable_telemetry         = var.enable_telemetry
  lock                     = var.lock
  role_assignments         = var.role_assignments
  sharing                  = var.sharing
  tags                     = var.tags
  timeouts                 = var.timeouts
}

resource "azurerm_shared_image_version" "this" {
  for_each            = local.images_definition
  name                = each.value.name
  gallery_name        = each.value.gallery_name
  image_name          = each.value.image_def_name
  resource_group_name = each.value.resource_group_name
  location            = try(each.value.location, var.location)
  managed_image_id    = try(each.value.managed_image_id, null)


  target_region {
    name                   = each.value.location
    regional_replica_count = each.value.target_region.regional_replica_count
    storage_account_type   = each.value.target_region.storage_account_type
  }
  depends_on = [module.compute_gallery]
}
