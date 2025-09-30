resource_group_name = "rg-nomad"
location            = "East US"
vmss_name           = "vmss-nomad"
shared_image_definitions = {
    img01 = {
    name               = "nomad"
      hyper_v_generation = "V2"
      os_type            = "Linux"
      identifier = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts-gen2"
      }
    }
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
instances = 1
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
    # user_data_base64                = "user-data-server.sh"   
    user_data_base64                = "user-data-client.sh"   
    admin_username                  = "azureuser"
    patch_mode                      = "ImageDefault"
  }
}
sku_name = "Standard_B1s"
 admin_password                = "aziresdf324#@!"
tags = {
  environment     = "dev"
  type            = "nomad"
  # applicationRole = "server"
  ConsulAutoJoin  = "auto-join"
}


## Module avm VM Variables 
  vm_mod_server_count             = 1
vm_mod_os_type = "Linux"
vm_mod_zone = null
vm_mod_network_interfaces = {
    network_interface_1 = {
      name = "vm-nomad-server-nic"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "vm-nomad-server-ipconfig"          
          create_public_ip_address      = true
          public_ip_address_name        = "vm-nomad-server-pip"
        }
      }    
    }
  }
