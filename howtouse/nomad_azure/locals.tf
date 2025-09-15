locals {
  os_profile = merge(var.os_profile, {
    custom_data = base64encode(file(var.os_profile.custom_data))
    linux_configuration = merge(var.os_profile.linux_configuration, {
      user_data_base64 = base64encode(file(var.os_profile.linux_configuration.user_data_base64))
      admin_ssh_key    = toset([tls_private_key.example_ssh.id])
    })
  })

}