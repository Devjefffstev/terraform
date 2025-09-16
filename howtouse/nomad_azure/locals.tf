locals {
  os_profile = merge(var.os_profile, {
    custom_data = base64encode(file(var.os_profile.custom_data))
    linux_configuration = merge(var.os_profile.linux_configuration, {
      user_data_base64 = base64encode(file(var.os_profile.linux_configuration.user_data_base64))
      admin_ssh_key    = toset([tls_private_key.example_ssh.id])
    })
  })
  os_profile_client = {
  custom_data = "custom-data.yaml"
  linux_configuration = {
    disable_password_authentication = false
    user_data_base64                = "user-data-server.sh"   
    admin_username                  = "azureuser"
    patch_mode                      = "ImageDefault"
  }
}
   admin_ssh_keys = [(
    {
      id         = tls_private_key.example_ssh.id
      public_key = tls_private_key.example_ssh.public_key_openssh
      username   = "azureuser"
    }
  )]
  network_interface = [
    for nic in var.network_interface : merge(nic, {
      # network_security_group_id = azurerm_network_security_group.subnet.id
      ip_configuration = [
        for ip in nic.ip_configuration : merge(ip, {
          subnet_id = azurerm_subnet.subnet.id
          public_ip_address = [{
            
            name = "vmss_nomad_ip_name"
           sku                 = "Standard"
          }]
        })
      ]
    })
  ]
  source_image_id = (
    var.source_image_id == null && var.source_image_reference == null ?
    data.azurerm_shared_image_version.this.id :
    var.source_image_id
  )
  nsg_rules = {
    anyportip = {
       access                     = "Allow"
    destination_address_prefix = "*"
    destination_port_range     = "*"
    direction                  = "Inbound"
    name                       = "allow-http"
    priority                   = 100
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    }
  }
}

