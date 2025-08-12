output "resource_group_prop_all" {
  description = "All resource group properties"
  value       = azurerm_resource_group.main_for_each  
}
output "resource_group_names" {
    description = "values for resource group names"
    value = [for rg_name, props in azurerm_resource_group.main_for_each : rg_name]
}


