terraform {
  backend "azurerm" {
	storage_account_name  = "terraformjefferson"
	container_name        = "tfstatejeff"
	key                   = "terraform.tfstatejeff"
  snapshot              = true
  }
}