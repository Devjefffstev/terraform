variable "name_prefix" {
  description = "Prefix used to name various infrastructure components. Alphanumeric characters only."
  default     = "poc"
}

variable "client_id" {
  description = "Azure client ID from federated identity"
  type        = string
}

variable "tenant_id" {
  description = "Azure Active Directory Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}