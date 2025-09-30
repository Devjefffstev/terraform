packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2.0.5"
    }
  }
}

source "azure-arm" "hashistack" {
  use_azure_cli_auth = true
  location            = var.location
  os_type             = var.os_type
  image_publisher    = var.image_publisher
  image_offer        = var.image_offer
  image_sku          = var.image_sku
  vm_size             = var.vm_size

 shared_image_gallery_destination {
    subscription         = var.subscription_id
    resource_group       = var.azurerm_shared_image_version_object.resource_group_name
    gallery_name         = var.azurerm_shared_image_version_object.gallery_name
    image_name           = var.azurerm_shared_image_version_object.image_name
    image_version        = var.azurerm_shared_image_version_object.name
    replication_regions  = ["East US"]
    storage_account_type = "Standard_LRS"
  }
}

build {
  sources = ["source.azure-arm.hashistack"]

  provisioner "shell" {
    inline = ["sudo mkdir -p /ops/shared", "sudo chmod 777 -R /ops"]
  }

  provisioner "file" {
    destination = "/ops"
    source      = "../shared"
  }

  provisioner "shell" {
    # workaround to cloud-init deleting apt lists while apt-update runs from setup.sh
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    environment_vars = ["INSTALL_NVIDIA_DOCKER=false", "CLOUD_ENV=azure"]
    script           = "../shared/scripts/setup.sh"
  }
  #The following provisioner snippet shows how to deprovision a Linux VM. Deprovision should be the last operation executed by a build.
  provisioner "shell" {
   execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
   inline = [
        "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
   ]
   inline_shebang = "/bin/sh -x"
}

}


variable "location" {}
variable "os_type" {}
variable "image_publisher" {}
variable "image_offer" {}
variable "image_sku" {}
variable "vm_size" {}
variable "azurerm_shared_image_version_object" {}
variable "subscription_id" {}


