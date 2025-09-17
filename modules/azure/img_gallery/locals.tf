
locals {
  ## Extracting the image definition that will be created
  images_definition = {
    for v in flatten(
      [
        for name, shd_img_def in var.shared_image_definitions : [
          for img in try(can(shd_img_def.image_version, []), []) : {
            resource_group_name  = var.resource_group_name
            image_def_name       = name
            managed_image_id     = try(img.managed_image_id, null)
            name                 = img.image_name
            location             = var.location
            target_region_name   = img.target_region.name
            target_replica_count = img.target_region.regional_replica_count
            storage_account_type = img.target_region.storage_account_type
          }
        ]
      ]
    ) : "${v.image_def_name}-${v.name}" => v
  }
}
