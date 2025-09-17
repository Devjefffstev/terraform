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
            sku  = "Standard"
          }]
        })
      ]
    })
  ]

  ## Network Interfaces for VM AVM
  network_interfaces = {
    for k, v in var.vm_mod_network_interfaces : k => merge(
      v,
      {
        ip_configurations = {
          for ipk, ip in v.ip_configurations : ipk => merge(ip,
            {
              private_ip_subnet_resource_id = azurerm_subnet.subnet.id
          })
        }
      }
    )
  }
  account_credentials = {
    admin_credentials = {
      username = "ubuntu"
      password = "azure123!!ASD"
      # ssh_keys                           = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3VgU6vbzgBk9XPqOIIia7eK6RrbWvpM+BXoilssi6GskaK90L29G3tqrUiSrdzu9ifEwToXo6XBky0xunb8kGqCNkp0qNwMYx+YzspoDzz/Rzyy4/gOxVbGdWFsmaS90p8Xtyx136TKtnSDmk8XlCMQX3mUrIDxEX6tGr3enkdEpL72fv+//Ge6NV6dGw7eHs2+oY3HJYJ9mYNW2x5G4DBioJljhAkQMljW3pFRclYPe8xTJFD6BHNP6iyOgzeNwFxxQL20VqhG9iQYPKPx6tMnX03NYsv/3LGx56T8rRQf3bQCVWuUVrmcegnQrGANc4NZOiRH14rTU+YJj2zrUYwkuXxjZMxpACosO8k2obcVQZRkZ6e1u8VpXbIl9IPSIfV2wfviglXqGg2U3uIdGtyag3jLxriYPEGKOOtAVN/pzwqAk3uwEiIbvOLbXTJ0cqD/bvqPqOUzHTMhldlBpAlbHuLeUt5zUICrdRWRy8DlqHGvdoO0S221BtQhcemXM="]
      generate_admin_password_or_ssh_key = false
    }
    password_authentication_disabled = false
  }

  custom_data = (base64encode(templatefile("user-data-server.sh", {
    region                    = var.location
    cloud_env                 = "azure"
    server_count              = "${var.vm_mod_server_count}"
    retry_join                = local.retry_join
    nomad_binary              = var.nomad_binary
    nomad_version             = var.nomad_version
    nomad_consul_token_id     = var.nomad_id
    nomad_consul_token_secret = var.nomad_secret
  })))

  ## General variables 
  vm_mod_source_image_resource_id = local.source_image_id
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

