# Hardcoded Azure Resource Group
resource "azurerm_resource_group" "pre_infra_rg" {
  name     = "rg-pre-infra"
  location = "East US"
}

# Hardcoded Azure Virtual Network (VNet)
resource "azurerm_virtual_network" "pre_infra_vnet" {
  name                = "vnet-pre-infra"
  resource_group_name = azurerm_resource_group.pre_infra_rg.name
  location            = azurerm_resource_group.pre_infra_rg.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"] # Optional DNS servers
  tags = {
    environment = "test"
    type        = "pre-infra"
  }
}

# Hardcoded Azure Subnet
resource "azurerm_subnet" "pre_infra_subnet" {
  name                 = "subnet-pre-infra"
  resource_group_name  = azurerm_resource_group.pre_infra_rg.name
  virtual_network_name = azurerm_virtual_network.pre_infra_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Hardcoded Output Values (optional for downstream use or tests)
output "resource_group_name" {
  value = azurerm_resource_group.pre_infra_rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.pre_infra_rg.location
}

output "virtual_network_name" {
  value = azurerm_virtual_network.pre_infra_vnet.name
}

output "subnet_name" {
  value = azurerm_subnet.pre_infra_subnet.name
}

output "subnet_id" {
  value = azurerm_subnet.pre_infra_subnet.id
}