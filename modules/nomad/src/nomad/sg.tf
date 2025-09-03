resource "azurerm_network_security_group" "nomad-sg" {
  name                = "hashistack-sg"
  location            = "East US"
  resource_group_name = "rg-nomad-eus-sbx"
}

resource "azurerm_network_security_rule" "nomad_ui_ingress" {
  name                        = "${var.name_prefix}-nomad-ui-ingress"
  resource_group_name         = "rg-nomad-eus-sbx"
  network_security_group_name = azurerm_network_security_group.nomad-sg.name

  priority  = 101
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "0.0.0.0/0"
  source_port_range          = "*"
  destination_port_range     = "4646"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "consul_ui_ingress" {
  name                        = "${var.name_prefix}-consul-ui-ingress"
  resource_group_name         = "rg-nomad-eus-sbx"
  network_security_group_name = azurerm_network_security_group.nomad-sg.name

  priority  = 102
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "0.0.0.0/0"
  source_port_range          = "*"
  destination_port_range     = "8500"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "ssh_ingress" {
  name                        = "${var.name_prefix}-ssh-ingress"
  resource_group_name         = "rg-nomad-eus-sbx"
  network_security_group_name = azurerm_network_security_group.nomad-sg.name

  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "0.0.0.0/0"
  source_port_range          = "*"
  destination_port_range     = "22"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "allow_all_internal" {
  name                        = "${var.name_prefix}-allow-all-internal"
  resource_group_name         = "rg-nomad-eus-sbx"
  network_security_group_name = azurerm_network_security_group.nomad-sg.name

  priority  = 103
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_address_prefix      = "10.0.0.0/16"
  source_port_range          = "*"
  destination_port_range     = "*"
  destination_address_prefix = "10.0.0.0/16"
}

# resource "azurerm_network_security_rule" "clients_ingress" {
#   name                        = "${var.name_prefix}-clients-ingress"
#   resource_group_name         = "rg-nomad-eus-sbx"
#   network_security_group_name = "${azurerm_network_security_group.nomad-sg.name}"

#   priority  = 110
#   direction = "Inbound"
#   access    = "Allow"
#   protocol  = "Tcp"

#   source_address_prefix      = "0.0.0.0/0"
#   source_port_range          = "*"
#   destination_port_range     = "80"
#   destination_address_prefixes = azurerm_linux_virtual_machine.client[*].public_ip_address
# }