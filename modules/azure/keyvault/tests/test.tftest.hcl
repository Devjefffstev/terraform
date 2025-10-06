mock_provider "azurerm" {
  alias = "fake"
  mock_resource "azurerm_key_vault" {
    defaults = {      
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.KeyVault/vaults/mock-keyvault"
    }
    
  }
}

run "name_regex_length_long" {
  providers = {
    azurerm = azurerm.fake
  }
  command = plan

  variables {
    key_vault_name = "abcdefghijklmnopqrstuvwxy"
  }

  expect_failures = [var.key_vault_name]
}

run "name_regex_length_short" {
  providers = {
    azurerm = azurerm.fake
  }
  command = plan

  variables {
    key_vault_name = "ab"
  }

  expect_failures = [var.key_vault_name]
}

run "name_regex_no_double_dashes" {
  providers = {
    azurerm = azurerm.fake
  }
  command = plan

  variables {
    key_vault_name = "ab--2"
  }

  expect_failures = [var.key_vault_name]
}

run "name_regex_must_start_with_letter" {
  providers = {
    azurerm = azurerm.fake
  }
  command = plan

  variables {
    key_vault_name = "6test"
  }

  expect_failures = [var.key_vault_name]
}

run "name_regex_must_end_with_letter_or_number" {
  providers = {
    azurerm = azurerm.fake
  }
  command = plan

  variables {
    key_vault_name = "test-"
  }

  expect_failures = [var.key_vault_name]
}

run "check_properties" {
providers = {
    azurerm = azurerm.fake
}
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

run "apply_legacy_access_policies" {
  providers = {
    azurerm = azurerm.fake
  }
  variables {    
    legacy_access_policies = {
      test = {
        object_id               = "00000000-0000-0000-0000-000000000000"
        certificate_permissions = ["Backup", "Create", "Delete"]
      }
    }
  }
  command = apply  
  
}

run "apply_key_vault_objects" {
  providers = {
    azurerm = azurerm.fake
  }
  variables {
    key_vault_objects = {
      cert1 = {
        certificate_data = "tests/certificate-to-import.pfx"
        password         = "P@ssw0rd!"
      }
       "secret-for-x" = {
    value = "testingsecret"

  }
    }
  }
  command = apply
  
}