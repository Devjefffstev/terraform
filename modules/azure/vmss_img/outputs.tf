
output "shared_image_galleries" {
  value = local.shared_image_galleries
  
}
output "source_image_id" {
  value = local.source_image_id
  
}
output "images_definition" {
  value = local.images_definition
}

output "imagaes_created" {
    value = azurerm_shared_image_version.this  
}