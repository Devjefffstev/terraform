data "azurerm_management_group" "mg" {
  name = var.management_group_name
}

resource "azurerm_policy_definition" "this" {
  name                = var.name
  policy_type         = var.policy_type
  mode                = var.mode
  display_name        = var.display_name
  description         = var.description
  management_group_id = data.azurerm_management_group.mg.id
  policy_rule         = var.policy_rule
  metadata            = var.metadata
  parameters          = var.parameters
}
