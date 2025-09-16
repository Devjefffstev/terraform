locals {
  os_profile = merge(var.os_profile, {
    custom_data = base64encode(file(var.os_profile.custom_data))
    linux_configuration = merge(var.os_profile.linux_configuration, {
      user_data_base64 = base64encode(file(var.os_profile.linux_configuration.user_data_base64))
      admin_ssh_key    = toset([tls_private_key.example_ssh.id])
    })
  })
   admin_ssh_keys = [(
    {
      id         = tls_private_key.example_ssh.id
      public_key = tls_private_key.example_ssh.public_key_openssh
      username   = "azureuser"
    }
  )]
  network_interface = [
    for nic in var.network_interface : merge(nic, {
      network_security_group_id = azurerm_network_security_group.nic.id
      ip_configuration = [
        for ip in nic.ip_configuration : merge(ip, {
          subnet_id = azurerm_subnet.subnet.id
        })
      ]
    })
  ]
  source_image_id = (
    var.source_image_id == null && var.source_image_reference == null ?
    data.azurerm_shared_image_version.this.id :
    var.source_image_id
  )
}

