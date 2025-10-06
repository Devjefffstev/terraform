mock_provider "azurerm" {
  alias = "fake"
  mock_resource "azurerm_key_vault" {
    defaults = {      
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.KeyVault/vaults/mock-keyvault"
    }
    
  }
}
run "check_name" {

  command = plan

  variables {
    sku_available = ["standard", "premium"]
    mock_key_vault_name = "test-bucket"
 
  }

  assert {
    condition     = azurerm_key_vault.this.name != var.mock_key_vault_name
    error_message = "The key vault name is not correct"
  }

  assert {
    condition     = anytrue([for sku in var.sku_available : azurerm_key_vault.this.sku_name == sku])
    error_message = "The keyvault sku is not valid"
  }
}

run "check_location" {
  command = plan

  variables {
    valid_locations = run.check_name.key_vault_properties.location
  }

  assert {
    condition     = var.valid_locations == "eastus2"
    error_message = "The location is not valid"

  }
}

run "run_fake_apply"{
  providers = {
    azurerm = azurerm.fake
  }
  command = apply
  
}