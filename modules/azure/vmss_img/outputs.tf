
## Outputs for the local values
output "shared_image_galleries" {
  value = local.shared_image_galleries

}
output "source_image_id" {
  value = local.source_image_id

}
output "images_definition" {
  value = local.images_definition
}

output "images_created" {
  value = azurerm_shared_image_version.this
}
output "list_images_create_vmss_with_this_image_true" {
  value = local.image_source_list_create_vmss_with_this_image_true
}

# Outputs for the resources created
output "vmss_id" {
  value = module.vmss

}
output "compute_gallery_id" {
  value = module.compute_gallery    
}
output "azurerm_shared_image_version_id" {
  value = azurerm_shared_image_version.this
  
}
  