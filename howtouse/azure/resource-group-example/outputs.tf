output "resource_group_example_for_each_inside_module" {
  description = "All resource group properties for for_each example"
  value       = module.resource_group_example_for_each_inside_module

}

output "resource_group_example_single_resource_group" {
  description = "All resource group properties when the ouput is a complex map"
  value = {
    for rgs in flatten([
      for rg_name, mod_outputs in module.resource_group_example_single_resource_group : [
        for mod_output_val in coalesce(mod_outputs, {}) : {
          name     = rg_name
          location = mod_output_val.location
          tags     = mod_output_val.tags
        }
      ]
    ]) : rgs.name => rgs
  }
}
output "resource_group_example_single_resource_group_all" {
  description = "All resource group properties for single example"
  value = module.resource_group_example_single_resource_group 
}
