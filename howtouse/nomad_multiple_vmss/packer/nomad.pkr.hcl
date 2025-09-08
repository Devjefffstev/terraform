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

  #uild_resource_group_name           = "rg-my-image-build"
  managed_image_name                  = var.managed_image_name
  managed_image_resource_group_name  = var.managed_image_resource_group_name
}

build {
  sources = ["source.azure-arm.hashistack"]

  provisioner "shell" {
    inline = ["sudo mkdir -p /ops/shared", "sudo chmod 777 -R /ops"]
  }

  provisioner "file" {
    destination = "/ops"
    source      = "./shared"
  }

  provisioner "shell" {
    # workaround to cloud-init deleting apt lists while apt-update runs from setup.sh
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    environment_vars = ["INSTALL_NVIDIA_DOCKER=false", "CLOUD_ENV=azure"]
    script           = "./shared/scripts/setup.sh"
  }
}


variable "location" {}
variable "os_type" {}
variable "image_publisher" {}
variable "image_offer" {}
variable "image_sku" {}
variable "vm_size" {}
variable "managed_image_name" {}
variable "managed_image_resource_group_name" {}


