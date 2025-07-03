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

## Example of how to use for_each in a module to create multiple resource groups overiting different properties
## In this case, we are overwriting the location of the resource group if the name contains "db"
locals {
  resource_group_prop_mod = {
    for rg_name, props in var.resource_group_prop_mod : rg_name => merge(props, {
      location = strcontains(rg_name, "db") ? "westus" : props.location
    })
  }
  resource_group_prop_mod_sing = {
    for rg_name, props in var.resource_group_prop_mod : rg_name => merge(props, {
      name    = "${rg_name}-single"
      location = strcontains(rg_name, "db") ? "westus" : props.location
    })
  }
}
## This module creates multiples resource groups using for_each in the resource block definition inside the module
module "resource_group_example_for_each_inside_module" {
  source              = "../../../../modules/azure/resource-group"
  resource_group_prop = local.resource_group_prop_mod
}

## This module creates multiples resource groups using for_each in the module block definition
module "resource_group_example_single_resource_group" {
  for_each                = local.resource_group_prop_mod_sing
  source                  = "../../../../modules/azure/resource-group-single"
  rg_prop_name_single     = each.value.name
  rg_prop_location_single = each.value.location
  rg_prop_tags_single     = try(each.value.tags, null)
}

