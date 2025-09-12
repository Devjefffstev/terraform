
locals {
  shared_image_galleries = var.source_image_id == null && var.source_image_reference == null ? (
    { for key_gallery, gallery in var.image_galleries : key_gallery => merge(gallery,
      {
        resource_group_name = gallery.resource_group_name == null ? var.resource_group_name : gallery.resource_group_name
        location            = gallery.location == null ? var.location : gallery.location
        shared_image_definitions = { for index, img in gallery.shared_image_definitions : "${img.name}-${index}" => img
        }
      }
    ) }
  ) : {}
  source_image_id = var.source_image_id == null && var.source_image_reference == null ? try(azurerm_shared_image_version.this[local.image_selected].id, "") : var.source_image_id

  image_selected = try(coalesce(local.image_source_list_create_vmss_with_this_image_true...), "")

  image_source_list_create_vmss_with_this_image_true = var.source_image_id == null && var.source_image_reference == null ? keys(
    {
      for k, v in local.images_definition : k => v
      if try(v.create_vmss_with_this_image, false)
    }
  ) : []


  images_definition = var.source_image_id == null && var.source_image_reference == null ? {
    for v in flatten(
      [
        for key_gallery, gallery in local.shared_image_galleries : [
          for img in gallery.shared_image_definitions : [
            for image in try(img.image_version, {}) : merge(image, {
              gallery_name        = key_gallery
              resource_group_name = gallery.resource_group_name
              image_def_name      = img.name
              managed_image_id    = try(image.managed_image_id, null)
              name                = image.image_name
              location            = try(gallery.location, var.location)
            })
          ]
        ]
      ]
    ) : "${v.image_def_name}-${v.name}" => v
  } : {}

}
