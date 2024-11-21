variable "key_vault_name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "location" {
  description = "The location of the Key Vault."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "enabled_for_disk_encryption" {
  description = "Whether the Key Vault is enabled for disk encryption."
  type        = bool
  default     = false
}

variable "tenant_id" {
  description = "The tenant ID for the Key Vault."
  type        = string
}

variable "soft_delete_retention_days" {
  description = "The number of days to retain soft deleted items."
  type        = number
  default     = 7
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled."
  type        = bool
  default     = false
}

variable "sku_name" {
  description = "The SKU name for the Key Vault."
  type        = string
  default     = "standard"
}

variable "enable_rbac_authorization" {
  description = "Whether to enable RBAC authorization for the Key Vault."
  type        = bool
  default     = false
}

variable "access_policy" {
  type = list(object({
    object_id           = string
    key_permissions     = list(string)
    secret_permissions  = list(string)
    storage_permissions = list(string)
  }))
}

variable "keyvault_objects" {
  type = map(object({
    ## fill this to create a secret
    value        = optional(string)
  }))
}
