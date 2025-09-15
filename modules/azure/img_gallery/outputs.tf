
## Outputs for the local values
output "shared_image_galleries" {
  value = module.compute_gallery

}
output "shared_images_created" {
  value = azurerm_shared_image_version.this
}

