## Outputs for Module Network Security Group
# name
# Description: The name of the Network Security Group resource

# resource
# Description: The Network Security Group resource

# resource_id
# Description: The id of the Network Security Group resource
output "network_security_group_prop" {
  value = module.avm-res-network-networksecuritygroup
}



# ## Outputs for the local values
# output "shared_image_galleries" {
#   value = local.shared_image_galleries

# }
# output "source_image_id" {
#   value = local.source_image_id

# }
# output "images_definition" {
#   value = local.images_definition
# }

# output "images_created" {
#   value = azurerm_shared_image_version.this
# }
# output "list_images_create_vmss_with_this_image_true" {
#   value = local.image_source_list_create_vmss_with_this_image_true
# }

# # Outputs for the resources created
# output "vmss_prop" {
#   value = module.vmss

# }
# output "compute_gallery_prop" {
#   value = module.compute_gallery
# }
# output "azurerm_shared_image_version_prop" {
#   value = azurerm_shared_image_version.this

# }
  