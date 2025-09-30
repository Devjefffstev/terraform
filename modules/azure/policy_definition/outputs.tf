output "id" {
  description = "The ID of the Policy Definition."
  value       = azurerm_policy_definition.this.id
}

output "role_definition_ids" {
  description = "A list of role definition id extracted from policy_rule required for remediation."
  value       = azurerm_policy_definition.this.role_definition_ids
}

output "azurerm_policy_definition_properties" {
  description = "All properties of the Policy Definition"
  value       = azurerm_policy_definition.this
}