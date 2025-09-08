terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  # backend "azurerm" {
  #   use_oidc         = true
  #   use_azuread_auth = true
  # }

}

provider "azurerm" {
  subscription_id                 = var.subscription_id
  # client_id                       = var.client_id
  # # storage_use_azuread             = true
  # resource_provider_registrations = "none"
  # use_oidc                        = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false // TODO; required?
    }
  }
}
