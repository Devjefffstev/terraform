## Outputs for Module Network Security Group
# name
# Description: The name of the Network Security Group resource
# resource
# Description: The Network Security Group resource
# resource_id
# Description: The id of the Network Security Group resource
output "network_security_group_prop" {
  value = module.avm_res_network_networksecuritygroup
}

## Outputs for Moduel Virtual Machine Scale Set
# resource
# Description: All attributes of the Virtual Machine Scale Set resource.
# resource_id
# Description: The ID of the Virtual Machine Scale Set.
# resource_name
# Description: The name of the Virtual Machine Scale Set.
output "vmss_prop" {
  value     = module.vmss
  sensitive = true
}