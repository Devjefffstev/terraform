# To run this example for first time you must first run a plan targeting the data source to ensure the image is created before applying the VMSS module
# terraform plan -out='plan' -var-file='example_vars/example_on_vmss_and_one_compute_gallery.tfvars' -target=data.azurerm_image.latest_nomad_image; terraform apply "plan"

# Then you can run the full apply
# terraform plan -out='plan' -var-file='example_vars/example_on_vmss_and_one_compute_gallery.tfvars'; terraform apply "plan"

# If you want to force the recreation of the image you can set the variable create_packer_image to true in the tfvars file targeting the data source first and then run the full apply
# terraform plan -out='plan' -var-file='example_vars/example_on_vmss_and_one_compute_gallery.tfvars' -var='create_packer_image=true'; terraform apply "plan"


module "example_on_vmss_and_one_compute_gallery" {
  source                        = "../../modules/azure/vmss_img"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  vmss_name                     = var.vmss_name
  user_data_base64              = var.user_data_base64
  additional_capabilities       = var.additional_capabilities
  admin_password                = var.admin_password
  admin_ssh_keys                = var.admin_ssh_keys
  automatic_instance_repair     = var.automatic_instance_repair
  boot_diagnostics              = var.boot_diagnostics
  capacity_reservation_group_id = var.capacity_reservation_group_id
  data_disk                     = var.data_disk
  enable_telemetry              = var.enable_telemetry
  encryption_at_host_enabled    = var.encryption_at_host_enabled
  eviction_policy               = var.eviction_policy
  extension                     = var.extension
  extension_operations_enabled  = var.extension_operations_enabled
  extensions_time_budget        = var.extensions_time_budget
  instances                     = var.instances
  license_type                  = var.license_type
  lock                          = var.lock
  managed_identities            = var.managed_identities
  max_bid_price                 = var.max_bid_price
  network_interface             = local.network_interface
  os_disk                       = var.os_disk
  os_profile                    = local.os_profile
  plan                          = var.plan
  platform_fault_domain_count   = var.platform_fault_domain_count
  priority                      = var.priority
  priority_mix                  = var.priority_mix
  proximity_placement_group_id  = var.proximity_placement_group_id
  role_assignments              = var.role_assignments
  single_placement_group        = var.single_placement_group
  sku_name                      = var.sku_name
  source_image_id               = var.source_image_id
  source_image_reference        = var.source_image_reference
  tags                          = var.tags
  termination_notification      = var.termination_notification
  timeouts                      = var.timeouts
  upgrade_policy                = var.upgrade_policy
  zone_balance                  = var.zone_balance
  zones                         = var.zones
  image_galleries               = local.image_galleries

  depends_on = [azurerm_nat_gateway.this, azurerm_network_security_group.nic, azurerm_subnet.subnet, azurerm_resource_group.nomad, terraform_data.packer_image, azurerm_virtual_network.this, azurerm_subnet_network_security_group_association.this, azurerm_nat_gateway_public_ip_association.this]
}

locals {
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
  os_profile = merge(var.os_profile, {
    custom_data = base64encode(file(var.os_profile.custom_data))
    linux_configuration = merge(var.os_profile.linux_configuration, {
      user_data_base64 = base64encode(file(var.os_profile.linux_configuration.user_data_base64))
      admin_ssh_key    = toset([tls_private_key.example_ssh.id])
    })
  })

  control_flag = !var.create_packer_image
  image_galleries = {
    for key_gallery, gallery in var.image_galleries : key_gallery => merge(gallery,
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
}

# output "module" {
#   value = module.example_on_vmss_and_one_compute_gallery
# }
output "network_interface" {
  value = local.network_interface

}
output "os_profile" {
  value = local.os_profile

}
output "image_galleries" {
  value = local.image_galleries

}

output "terraform_data" {
  value = terraform_data.packer_image

}