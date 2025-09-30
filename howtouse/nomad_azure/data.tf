data "azurerm_client_config" "current" {}
data "azuread_client_config" "current" {}

# data "azuread_application" "this" {
#   display_name = "test-jeff"
# }

# output "application_object_id" {
#   value = data.azuread_application.this.object_id
# }