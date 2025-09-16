locals {
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
  #Default NSG Rules for Nomad Cluster
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
  merge_rules= merge(
    local.nsg_rules, local.additional_rules
  )
}