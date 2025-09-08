packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2.0.5"
    }
  }
}

source "azure-arm" "ubuntu" {
  use_azure_cli_auth = true
  location            = "East US"
  os_type             = "Linux"
  image_publisher     = "Canonical"
  image_offer         = "0001-com-ubuntu-server-jammy"
  image_sku           = "22_04-lts-gen2"
  vm_size             = "Standard_B2s"

  #uild_resource_group_name           = "rg-my-image-build"
  managed_image_name                  = "ubuntu-custom-image"
  managed_image_resource_group_name  = "rg-my-image-build"
}

build {
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx"
    ]
  }
}
