terraform {
  backend "azurerm" {
	storage_account_name  = "tfstate1984 "
	container_name        = "tfstate"
	key                   = "terraform.tfstate"
    snapshot              = true
  }
}