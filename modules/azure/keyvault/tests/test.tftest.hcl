
run "check_name" {

  command = plan

  variables {
    sku_available = ["standard", "premium"]
    mock_key_vault_name = "test-bucket"
 
  }

  assert {
    condition     = azurerm_key_vault.main.name != var.mock_key_vault_name
    error_message = "The key vault name is not correct"
  }

  assert {
    condition     = anytrue([for sku in var.sku_available : azurerm_key_vault.main.sku_name == sku])
    error_message = "The keyvault sku is not valid"
  }
}

run "check_location" {
  command = plan

  variables {
    valid_locations = run.check_name.output_keyvault_info.location
  }

  assert {
    condition     = var.valid_locations == "eastus2"
    error_message = "The location is not valid"

  }
}

