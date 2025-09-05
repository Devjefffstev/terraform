
locals {
  shared_image_galleries = var.source_image_id != null ? (
    { for key_gallery, gallery in var.image_galleries : key_gallery => merge(gallery,
      {
        resource_group_name = gallery.resource_group_name != null ? var.resource_group_name : gallery.resource_group_name
        location            = gallery.location != null ? var.location : gallery.location
        shared_image_definitions = { for index, img in gallery.shared_image_definitions : "${key_gallery}${index}" => merge(img,
          {
            name = "${key_gallery}${index}"
          }
          )
        }
      }
    ) }
  ) : {}
  source_image_id = ""

  images_def_id = {
    for v in flatten(
      [
        for key_gallery, gallery in local.shared_image_galleries : [
          for img in gallery.shared_image_definitions : {
            gallery_name        = key_gallery
            resource_group_name = gallery.resource_group_name
            image_name          = img.name
          }
        ]
      ]
    ) : k => v
  }

}

