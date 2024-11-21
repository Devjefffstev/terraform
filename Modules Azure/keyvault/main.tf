resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled
  sku_name                    = var.sku_name
  enable_rbac_authorization   = try(var.enable_rbac_authorization, null)

  dynamic "access_policy" {
    for_each = local.access_policy
    content {
      tenant_id           = access_policy.value["tenant_id"]
      object_id           = access_policy.value["object_id"]
      key_permissions     = access_policy.value["key_permissions"]
      secret_permissions  = access_policy.value["secret_permissions"]
      storage_permissions = access_policy.value["storage_permissions"]
    }

  }

}

resource "azurerm_key_vault_secret" "main" {
  for_each     = var.keyvault_objects
  name         = each.key
  value        = each.value.value
  key_vault_id = azurerm_key_vault.main.id
}
