location                        = "East US"
os_type                         = "Linux"
image_publisher                 = "Canonical"
image_offer                     = "0001-com-ubuntu-server-jammy"
image_sku                       = "22_04-lts-gen2"
vm_size                         = "Standard_B2s"


azurerm_shared_image_version_object = {
     name = "0.0.1"
    gallery_name = "vmss_nomad_comp_gallery"
   resource_group_name = "rg-nomad"
   image_name="nomad"

}