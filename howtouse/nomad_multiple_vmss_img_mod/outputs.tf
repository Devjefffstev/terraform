output "module" {
  value = module.example_multiple_vmss_one_gallery
  #   sensitive = true
}


# output "terraform_data" {
#   value = terraform_data.packer_image

# }

output "local_image" {
  value = local.vmss_config_map
}

output "data_image_version" {
  value = local.data_image_version
}