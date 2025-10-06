output "key_vault_properties" {
  value       = azurerm_key_vault.this
  description = "Properties of the key vault"
}
output "keyvault_secret_info" {
  value       = azurerm_key_vault_secret.this
  description = "Properties of the key vault secret"
  sensitive   = true
}

