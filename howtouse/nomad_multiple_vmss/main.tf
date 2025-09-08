# To run this example for first time you must first run a plan targeting the data source to ensure the image is created before applying the VMSS module
# terraform plan -out='plan' -var-file='example_vars/example.tfvars' -target=data.azurerm_image.latest_nomad_image; terraform apply "plan"

# Then you can run the full apply
# terraform plan -out='plan' -var-file='example_vars/example.tfvars'; terraform apply "plan"

# If you want to force the recreation of the image you can set the variable create_packer_image to true in the tfvars file targeting the data source first and then run the full apply
# terraform plan -out='plan' -var-file='example_vars/example.tfvars' -var='create_packer_image=true'; terraform apply "plan"

module "example_multiple_vmss_one_gallery" {
  for_each                      = local.vmss_config_map
  source                        = "../../modules/azure/vmss_img"
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  vmss_name                     = each.value.vmss_name
  user_data_base64              = each.value.user_data_base64
  additional_capabilities       = each.value.additional_capabilities
  admin_password                = each.value.admin_password
  admin_ssh_keys                = each.value.admin_ssh_keys
  automatic_instance_repair     = each.value.automatic_instance_repair
  boot_diagnostics              = each.value.boot_diagnostics
  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  data_disk                     = each.value.data_disk
  enable_telemetry              = each.value.enable_telemetry
  encryption_at_host_enabled    = each.value.encryption_at_host_enabled
  eviction_policy               = each.value.eviction_policy
  extension                     = each.value.extension
  extension_operations_enabled  = each.value.extension_operations_enabled
  extensions_time_budget        = each.value.extensions_time_budget
  instances                     = each.value.instances
  license_type                  = each.value.license_type
  lock                          = each.value.lock
  managed_identities            = each.value.managed_identities
  max_bid_price                 = each.value.max_bid_price
  network_interface             = each.value.network_interface
  os_disk                       = each.value.os_disk
  os_profile                    = each.value.os_profile
  plan                          = each.value.plan
  # platform_fault_domain_count   = each.value.platform_fault_domain_count
  # priority                      = each.value.priority
  priority_mix                  = each.value.priority_mix
  proximity_placement_group_id  = each.value.proximity_placement_group_id
  role_assignments              = each.value.role_assignments
  single_placement_group        = each.value.single_placement_group
  sku_name                      = each.value.sku_name
  source_image_id               = each.value.source_image_id
  source_image_reference        = each.value.source_image_reference
  tags                          = each.value.tags
  termination_notification      = each.value.termination_notification
  timeouts                      = each.value.timeouts
  # upgrade_policy                = each.value.upgrade_policy
  zone_balance                  = each.value.zone_balance
  zones                         = each.value.zones
  image_galleries               = each.value.image_galleries


  depends_on = [
    azurerm_nat_gateway.this,
    azurerm_network_security_group.nic,
    azurerm_subnet.subnet,
    azurerm_resource_group.nomad,
    terraform_data.packer_image,
    azurerm_virtual_network.this,
    azurerm_subnet_network_security_group_association.this,
    azurerm_nat_gateway_public_ip_association.this
  ]
}

locals {
  vmss_config_map = {
    for k, v in var.vmss_config_map : k => merge(v, {
      network_interface = [
        for nic in v.network_interface : merge(nic, {
          network_security_group_id = azurerm_network_security_group.nic.id
          ip_configuration = [
            for ip in nic.ip_configuration : merge(ip, {
              subnet_id = azurerm_subnet.subnet.id
            })
          ]
        })
      ]
      os_profile = merge(v.os_profile, {
        custom_data = base64encode(file(v.os_profile.custom_data))
        linux_configuration = merge(v.os_profile.linux_configuration, {
          user_data_base64 = base64encode(file(v.os_profile.linux_configuration.user_data_base64))
          admin_ssh_key    = toset([tls_private_key.example_ssh.id])
        })
      })
      source_image_id = keys(var.vmss_config_map)[1] == k ? data.azurerm_image.latest_nomad_image.id : null


      image_galleries = {
        for key_gallery, gallery in v.image_galleries : key_gallery => merge(gallery,
          {
            shared_image_definitions = [
              for image_def in gallery.shared_image_definitions : merge(image_def,

                {
                  image_version = [
                    for image_version in image_def.image_version :
                    merge(image_version, {
                      #   managed_image_id = data.azurerm_image.latest_nomad_image.id ## golden image
                      managed_image_id = data.azurerm_image.latest_nomad_image.id
                      }
                    )
                  ]
                }
              )
            ]


        })
      }
    })
  }
}

output "module" {
  value = module.example_multiple_vmss_one_gallery
  sensitive = true
}


output "terraform_data" {
  value = terraform_data.packer_image

}