output "output_keyvault_info" {
  value       = azurerm_key_vault.main
  description = "Properties of the key vault"
}
output "output_keyvault_secret_info" {
  value       = azurerm_key_vault_secret.main
  description = "Properties of the key vault secret"
  sensitive   = true
}


