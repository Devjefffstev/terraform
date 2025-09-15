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
