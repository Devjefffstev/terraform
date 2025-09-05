output "image_versions_ids" {
  value = { for k, v in azurerm_shared_image_version.this : k => v.id }
  
}