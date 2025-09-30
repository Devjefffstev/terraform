## Retrieve the image created by Packer 
## Take a look at /nomad/packer/variables.pkr.hcl for reference

data "azurerm_image" "latest_nomad_image" {
  name                = "ubuntu-custom-image"
  resource_group_name = "rg-my-image-build"

  depends_on = [terraform_data.packer_image]
}

output "name" {

  value = data.azurerm_image.latest_nomad_image
}