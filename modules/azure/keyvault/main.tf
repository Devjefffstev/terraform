resource "azurerm_key_vault" "this" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled
  sku_name                    = var.sku_name

}

resource "azurerm_key_vault_secret" "this" {
  for_each     = local.key_vault_secrets
  name         = each.key
  value        = each.value.value
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_certificate" "this" {
for_each = local.key_vault_certificates
  name         = each.key
  key_vault_id = azurerm_key_vault.this.id

  certificate {
    contents = filebase64(each.value.certificate_data)
    password = each.value.password
  }
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_key_vault.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  principal_type                         = each.value.principal_type
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_key_vault_access_policy" "this" {
  for_each = var.legacy_access_policies

  key_vault_id            = azurerm_key_vault.this.id
  object_id               = each.value.object_id
  tenant_id               = var.tenant_id
  application_id          = each.value.application_id
  certificate_permissions = each.value.certificate_permissions
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  storage_permissions     = each.value.storage_permissions
}
