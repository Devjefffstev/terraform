terraform {
  # backend "azurerm" {
  #   storage_account_name = "value"
  #   resource_group_name  = "value"
  #   container_name       = "value"
  #   key                  = "value"
  #   subscription_id      = "value"
  #   snapshot             = true
  # }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.10.0"
    }
  }
}
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = "805ee16f-21b1-48ee-bfb8-05acdad39bd3"
}
