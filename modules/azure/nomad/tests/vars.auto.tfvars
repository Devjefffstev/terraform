# Core required variables
resource_group_name = "my-rg-pricipal"
location            = "eastus"
environment         = "test"
app_function_chatam = "nomad"

vmss_name = "vmss-nomad-one-and-one"
# source_image_id="/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/rg-my-image-build/providers/Microsoft.Compute/images/ubuntu-custom-image"
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


sku_name       = "Standard_B1s"
admin_password = "aziresdf324#@!"
tags = {

}

## Azure VM 
vm_mod_name = "azure-vm-module"
vm_mod_zone = null
vm_mod_network_interfaces = {
  network_interface_1 = {
    name = "vm-nomad-client-eus-sbx-nic"
    ip_configurations = {
      ip_configuration_1 = {
        name                          = "vm-nomad-client-eus-sbx-ipconfig"
        private_ip_subnet_resource_id = "/subscriptions/ae8fb469-4dad-482c-80e7-00bde08748b1/resourceGroups/rg-nomad-eus-sbx/providers/Microsoft.Network/virtualNetworks/vnet-nomad-eus-sbx/subnets/default"
        create_public_ip_address      = true
        public_ip_address_name        = "vm-nomad-client-eus-sbx-pip"
      }
    }
    network_security_groups = {
      network_interface_1 = {
        network_security_group_resource_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/networkSecurityGroups/networkSecurityGroupName"
      }
    }
  }
}