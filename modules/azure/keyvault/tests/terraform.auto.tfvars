
key_vault_name              = "examplekeyvault"
location                    = "eastus2"
resource_group_name         = "example-resource-group"
enabled_for_disk_encryption = false
soft_delete_retention_days  = 7
purge_protection_enabled    = false
sku_name                    = "standard"
enable_rbac_authorization   = false

access_policy = [
  {
    object_id           = "abd5a32a-e2d8-49c8-af9b-1f61b180b4b1"
    key_permissions     = ["Get"]
    secret_permissions  = ["Get"]
    storage_permissions = ["Get"]
  }
]
keyvault_objects = {
  "secret-for-x" = {
    value = "testingsecret"

  }
}
