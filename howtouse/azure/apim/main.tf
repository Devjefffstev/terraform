## AVM modules for Azure API Management (APIM)
module "avm-res-apimanagement-service" {
  source  = "Azure/avm-res-apimanagement-service/azurerm"
  version = "0.0.5"
  # insert the 4 required variables here
  name= "example-apim"
    location = "West Europe"
    resource_group_name = "example-resources"
    publisher_name = "example-publisher"
    publisher_email = "example@example.com"
}
