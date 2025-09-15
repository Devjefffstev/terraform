# ## validation of existing resources in the module
# data "azurerm_resources" "gallery_already_created" {
#   for_each            = local.existing_agc
#   name                = each.key
#   type                = "Microsoft.Compute/galleries"
#   resource_group_name = each.value.resource_group_name
# }

# locals {

#   existing_agc = var.source_image_id == null && var.source_image_reference == null ? (
#     { for key_gallery, gallery in var.image_galleries : key_gallery => merge(gallery,
#       {
#         resource_group_name = gallery.resource_group_name == null ? var.resource_group_name : gallery.resource_group_name
#         location            = gallery.location == null ? var.location : gallery.location
#         shared_image_definitions = { for index, img in gallery.shared_image_definitions : "${img.name}-${index}" => img
#         }

#       }
#     ) }
#   ) : {}
#   filtering_existing_shared_images_version = {
#     for k, v in local.images_definition : k => merge(v,
#       {
#         exist = length(try(coalesce(try(azurerm_shared_image_version.this[k].id), []), [])) > 0 ? true : false
#     })
#     if try(v.purchase_plan, null) == null && try(v.identifier, null) == null && try(v.os_type, null) == null
#   }


# }