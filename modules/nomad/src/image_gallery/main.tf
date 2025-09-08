module "compute_gallery" {
  source = "Azure/avm-res-compute-gallery/azurerm"

  location            = "East US"
  name                = "nomadeussbxgall"
  resource_group_name = "rg-nomad-eus-sbx"
  ## Optional
  enable_telemetry = false
  description = "Nomad Image Gallery in East US"
  shared_image_definitions = {
    nomad = {
      name    = "nomad"
      hyper_v_generation = "V2"
      os_type = "Linux"
      identifier = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
      }
      purchase_plan = {
        name      = "22_04-lts-gen2"
        publisher = "Canonical"
        product   = "0001-com-ubuntu-server-jammy"
      }
    }
  
    testnomad = {
      name    = "testnomad"
      hyper_v_generation = "V2"
      os_type = "Linux"
     identifier = {
        publisher = "RedHat"
        offer     = "RHEL"
        sku       = "810-gen2"
      }
      purchase_plan = {
        name      = "22_04-lts-gen2"
        publisher = "Canonical"
        product   = "0001-com-ubuntu-server-jammy"
      }
    }
  }
  depends_on = [ azurerm_resource_group.name ]
}

resource "azurerm_resource_group" "name" {
  
  name     = "rg-nomad-eus-sbx"
  location = "East US"
}
resource "azurerm_resource_group" "nimages" {
  
  name     = "rg-my-image-build"
  location = "East US"
}

# resource "terraform_data" "name" {
  
#   provisioner "local-exec" {
#     command = "packer validate ../../packer/image.pkr.hcl"
#   }
#   provisioner "local-exec" {
#     command = "packer init ../../packer/image.pkr.hcl"
    
#   }

#   provisioner "local-exec" {
#     command = "packer build ../../packer/image.pkr.hcl"
#     # command = "echo 'Packer build command would go here'"
    
#   }
#   triggers_replace = {
#     always_run = timestamp()
#   }
# }

resource "azurerm_shared_image_version" "example" {
  name                = "0.0.1"
  gallery_name        = "nomadeussbxgall"
  image_name          = "testnomad"
  resource_group_name = "rg-nomad-eus-sbx"
  location            = "East US"
  managed_image_id    = "/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/rg-my-image-build/providers/Microsoft.Compute/images/ubuntu-custom-image"

  target_region {
    name                   = "East US"
    regional_replica_count = 1
    storage_account_type   = "Standard_LRS"
  }
}