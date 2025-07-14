terraform {
  backend "azurerm" {
	storage_account_name  = "terraform"
	container_name        = "tfstatejeff"
	key                   = "terraform.tfstatejeff"
    snapshot              = true
  }
}