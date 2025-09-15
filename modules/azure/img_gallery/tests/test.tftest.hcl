# variable "subscription_id" {
#   type        = string
#   description = "The Azure subscription ID for testing"
# }
# provider "azurerm" {
#   features {}
#   subscription_id = var.subscription_id
# }
mock_provider "azurerm" {
  alias = "fake_pre"
    source = "./tests/infra_pre_req/"
    override_during = apply
  mock_resource "azurerm_resource_group" {
    defaults = {
      id = "/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/my-resource-group"      
    }
  }
}
mock_provider "azurerm" {
  alias = "fake"
}

variables {
  resource_group_name = run.plan_pre.resource_group_name
}


run "plan_pre" {
    providers = {
      azurerm = azurerm.fake_pre
    }
  module {
    source = "./tests/infra_pre_req/"
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
run "apply" {
    providers = {
      azurerm = azurerm.fake
    }
  module {
    source = "./"
  }
}