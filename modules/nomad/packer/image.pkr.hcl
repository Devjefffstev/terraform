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
  os_type            = "Linux"
  image_publisher    = "Canonical"
  image_offer        = "0001-com-ubuntu-server-jammy"
  image_sku          = "22_04-lts-gen2"

  shared_image_gallery_destination {
    subscription         = "ae8fb469-4dad-482c-80e7-00bde08748b1"
    resource_group       = "rg-nomad-eus-sbx"
    gallery_name         = "nomadeussbxgall"
    image_name           = "nomad"
    image_version        = "0.0.1"
    replication_regions  = ["East US"]
    storage_account_type = "Standard_LRS"
  }

  build_resource_group_name = "rg-nomad-eus-sbx"
  vm_size  = "Standard_B2s"
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
}
