module "compute_gallery" {
  source = "Azure/avm-res-compute-gallery/azurerm"

  location            = "East US"
  name                = "nomadeussbxgall"
  resource_group_name = "rg-nomad-eus-sbx"
  ## Optional
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
  }
}