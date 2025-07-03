resource "azurerm_resource_group" "main_for_each" {
  for_each = var.resource_group_prop
  name     = each.key # Use the key as the name of the resource group
  location = each.value.location
  tags     = try(each.value.tags, null)
}
