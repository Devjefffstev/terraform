module "nomad-server" {

  extension_protected_setting = {}
  location                    = "East US"
  source                      = "Azure/avm-res-compute-virtualmachinescaleset/azurerm"
  name                        = "nomad-server"
  resource_group_name         = "rg-nomad-eus-sbx"
  user_data_base64            = null
  boot_diagnostics = {
    storage_account_uri = ""
  }
  enable_telemetry = false
  extension = [{
    name                        = "HealthExtension"
    publisher                   = "Microsoft.ManagedServices"
    type                        = "ApplicationHealthLinux"
    type_handler_version        = "1.0"
    auto_upgrade_minor_version  = true
    failure_suppression_enabled = false
    settings                    = "{\"port\":80,\"protocol\":\"http\",\"requestPath\":\"/index.html\"}"
  }]
  instances        = 3
  network_interface = [{
    name                      = "VMSS-NIC"
    network_security_group_id = azurerm_network_security_group.nomad-sg.id
    ip_configuration = [{
      name      = "VMSS-IPConfig"
      subnet_id = "/subscriptions/ae8fb469-4dad-482c-80e7-00bde08748b1/resourceGroups/rg-nomad-eus-sbx/providers/Microsoft.Network/virtualNetworks/vnet-nomad-eus-sbx/subnets/default"
    }]
  }]
  os_profile = {
    custom_data = base64encode(file("custom-data.yaml"))
    linux_configuration = {
      disable_password_authentication = true
      user_data_base64                = base64encode(file("user-data-server.sh"))
      admin_username                  = "azureuser"
      patch_mode                      = "ImageDefault"
    }
  }
  sku_name        = "Standard_B1s"
  source_image_id = "/subscriptions/ae8fb469-4dad-482c-80e7-00bde08748b1/resourceGroups/rg-nomad-eus-sbx/providers/Microsoft.Compute/galleries/nomadeussbxgall/images/nomad/versions/0.0.1"
  tags = {
    environment     = "dev"
    type            = "nomad"
    applicationRole = "server"
    ConsulAutoJoin  = "auto-join"
  }
}

module "nomad-client" {

  extension_protected_setting = {}
  location                    = "East US"
  source                      = "Azure/avm-res-compute-virtualmachinescaleset/azurerm"
  name                        = "nomad-client"
  resource_group_name         = "rg-nomad-eus-sbx"
  user_data_base64            = null
  boot_diagnostics = {
    storage_account_uri = ""
  }
  enable_telemetry = false
  instances        = 3
  network_interface = [{
    name                      = "VMSS-NIC"
    network_security_group_id = azurerm_network_security_group.nomad-sg.id
    ip_configuration = [{
      name      = "VMSS-IPConfig"
      subnet_id = "/subscriptions/ae8fb469-4dad-482c-80e7-00bde08748b1/resourceGroups/rg-nomad-eus-sbx/providers/Microsoft.Network/virtualNetworks/vnet-nomad-eus-sbx/subnets/default"
    }]
  }]
  os_profile = {
    custom_data = base64encode(file("custom-data.yaml"))
    linux_configuration = {
      disable_password_authentication = true
      user_data_base64                = base64encode(file("user-data-client.sh"))
      admin_username                  = "azureuser"
      patch_mode                      = "ImageDefault"
    }
  }
  sku_name        = "Standard_B1s"
  source_image_id = "/subscriptions/ae8fb469-4dad-482c-80e7-00bde08748b1/resourceGroups/rg-nomad-eus-sbx/providers/Microsoft.Compute/galleries/nomadeussbxgall/images/nomad/versions/0.0.1"
  tags = {
    environment     = "dev"
    type            = "nomad"
    applicationRole = "client"
    ConsulAutoJoin  = "auto-join"
  }
}
