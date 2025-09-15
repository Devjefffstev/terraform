# Core required variables
resource_group_name = "my-rg-pricipal"
location = "eastus"
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