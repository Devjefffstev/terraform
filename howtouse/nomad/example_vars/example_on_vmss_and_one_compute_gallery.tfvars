resource_group_name = "rg-nomad-one-and-one"
location            = "East US"
vmss_name           = "vmss-nomad-one-and-one"

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
instances = 3
network_interface = [{
  name = "VMSS-NIC"
  ip_configuration = [{
    name = "VMSS-IPConfig"
  }]
}]
os_profile = {
  custom_data = "custom-data.yaml"
  linux_configuration = {
    disable_password_authentication = false
    user_data_base64                = "user-data-server.sh"
   
    admin_username                  = "azureuser"
    patch_mode                      = "ImageDefault"
  }
}
sku_name = "Standard_B1s"
 admin_password                = "aziresdf324#@!"
tags = {
  environment     = "dev"
  type            = "nomad"
  applicationRole = "server"
  ConsulAutoJoin  = "auto-join"
}
image_galleries = {
  "acgnomad" = {
    shared_image_definitions = [{
      name               = "nomad"
      hyper_v_generation = "V2"
      os_type            = "Linux"
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
      image_version = [
        {
          image_name = "0.0.1"
          target_region = {
            name                   = "East US"
            regional_replica_count = 1
            storage_account_type   = "Standard_LRS"
          }
        }
      ]
    }]
  }
}