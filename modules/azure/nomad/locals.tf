locals {
  ## VMSS module
  ## Force to use `network_security_group` if it is not set by the user.
  network_interface = [
    for ni in var.network_interface : merge(
      ni,
      {
        network_security_group_id = ni.network_security_group_id == null ? module.avm_res_network_networksecuritygroup.resource_id : ni.network_security_group_id
      }
    )
  ]

  additional_rules = {
    for name, rule in try(var.nsg_rules, {}) : name => merge(
      rule, {
        name = "nsgr-${var.environment}-${var.app_function_chatam}-${lower(replace(var.location, " ", ""))}-${name}"
      }
    )
  }

## VM Module 
network_interfaces ={
  for key_nic, nic in var.vm_mod_network_interfaces : key_nic => merge(
    nic, 
    {
        network_security_groups = nic.network_security_groups != null ? {
          for nsgk, nsg in try(nic.network_security_groups,{}) : nsgk => merge(
            nsg,
            {
            network_security_group_resource_id = (
                nsg.network_security_group_resource_id == null ? module.        avm_res_network_networksecuritygroup.resource_id : 
                  nsg.network_security_group_resource_id
              )
          })
        } : null

    }
  )
}


  #Default NSG Rules for Nomad Cluster Server and Client
  nsg_rules = {
    "ssh_ingress" = {
      name                       = "nsgr-${var.environment}-${var.app_function_chatam}-${lower(replace(var.location, " ", ""))}-ssh-ingress"
      access                     = "Allow"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "22"
      direction                  = "Inbound"
      priority                   = 4092
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    }
    "nomad_ui_ingress" = {
      name                       = "nsgr-${var.environment}-${var.app_function_chatam}-${lower(replace(var.location, " ", ""))}-nomad-ui-ingress"
      access                     = "Allow"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "4646"
      direction                  = "Inbound"
      priority                   = 4095
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    }
    "consul_ui_ingress" = {
      name                       = "nsgr-${var.environment}-${var.app_function_chatam}-${lower(replace(var.location, " ", ""))}-consul-ui-ingress"
      access                     = "Allow"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "8500"
      direction                  = "Inbound"
      priority                   = 4094
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    }
    "allow_all_internal" = {
      name                       = "nsgr-${var.environment}-${var.app_function_chatam}-${lower(replace(var.location, " ", ""))}1-allow-all-internal"
      access                     = "Allow"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "*"
      direction                  = "Inbound"
      priority                   = 4093
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
    }
  }
  merge_rules = merge(
    local.nsg_rules, local.additional_rules
  )
}