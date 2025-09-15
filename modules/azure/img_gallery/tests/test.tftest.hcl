variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID for testing"
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
mock_provider "azurerm" {
  alias = "fake"
  mock_resource "azurerm_resource_group" {
    defaults = {
      id = "/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/my-resource-group"
    }
  }
}

run "plan" {
    providers = {
      azurerm = azurerm.fake
    }
  module {
    source = "./"
  }
}