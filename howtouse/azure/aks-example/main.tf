provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = var.subscription_id

}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.0"
    }
  }
}

module "resource_group_example_single_resource_group" {
  source                  = "../../../modules/azure/resource-group-single"
  rg_prop_name_single     = "rg-aks-poc-${var.name}"
  rg_prop_location_single = var.location  
}
output "rg-properties" {
  description = "All resource group properties"
  value       = module.resource_group_example_single_resource_group  
}

module "aks_poc" {
  source = "../../../modules/azure/aks"

  name                = "aks-poc-${var.name}"
  location            = var.location
  resource_group_name = module.resource_group_example_single_resource_group.resource_group_prop_single.name
  dns_prefix          = "aks-poc-${var.name}"
  
  default_node_pool = {
    name       = var.default_node_pool.name
    node_count = var.default_node_pool.node_count
    vm_size    = var.default_node_pool.vm_size 
  }

  identity = {
    type         = var.identity.type    
  }
}