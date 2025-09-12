# Core required variables
resource_group_name = "rg-nomad-test-001"
location            = "East US"
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
network_interface = [
  {
    name = "VMSS-NIC"
    ip_configuration = [{
      name = "VMSS-IPConfig"
      # subnet_id=              "/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/rg-nomad-test-001/providers/Microsoft.Network/virtualNetworks/MyVNet/subnets/MySubnet"
    }]
  }
]
os_profile = {
  # custom_data = "custom-data.yaml"
  linux_configuration = {
    disable_password_authentication = false
    # user_data_base64                = "user-data-server.sh"   
    admin_username = "azureuser"
    patch_mode     = "ImageDefault"
  }
}
sku_name       = "Standard_B1s"
admin_password = "aziresdf324#@!"
tags = {
  environment     = "dev"
  type            = "nomad"
  applicationRole = "server"
  ConsulAutoJoin  = "auto-join"
}