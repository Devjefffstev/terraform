resource "azurerm_resource_group" "main_single" {
  name     = var.rg_prop_name_single
  location = var.rg_prop_location_single
  tags     = try(var.rg_prop_tags_single, null)
}