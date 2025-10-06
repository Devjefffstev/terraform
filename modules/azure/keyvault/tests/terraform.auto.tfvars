
key_vault_name              = "examplekeyvault"
location                    = "eastus2"
resource_group_name         = "example-resource-group"
enabled_for_disk_encryption = false
soft_delete_retention_days  = 7
purge_protection_enabled    = false
sku_name                    = "standard"
enable_rbac_authorization   = false


key_vault_objects = {
  "secret-for-x" = {
    value = "testingsecret"

  }
}
