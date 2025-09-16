module "nomad_cluster" {
  source                        = "../../modules/azure/nomad"
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
  source_image_id               = local.source_image_id
  source_image_reference        = var.source_image_reference
  tags                          = var.tags
  termination_notification      = var.termination_notification
  timeouts                      = var.timeouts
  upgrade_policy                = var.upgrade_policy
  zone_balance                  = var.zone_balance
  zones                         = var.zones


  depends_on = [azurerm_nat_gateway.this, azurerm_network_security_group.nic, azurerm_subnet.subnet, azurerm_resource_group.nomad, azurerm_virtual_network.this, azurerm_subnet_network_security_group_association.this, azurerm_nat_gateway_public_ip_association.this, module.az_compute_galley, data.azurerm_shared_image_version.this, azurerm_bastion_host.example]
}

module "az_compute_galley" {
  source                   = "../../modules/azure/img_gallery"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  name                     = replace("${var.vmss_name}-comp-gallery", "-", "_")
  shared_image_definitions = var.shared_image_definitions

  depends_on = [azurerm_resource_group.nomad]
}

resource "terraform_data" "packer_image" {
  provisioner "local-exec" {
    command = <<EOT
      set -e
      IMAGE_NAME="${var.azurerm_shared_image_version_object.name}"
      RESOURCE_GROUP="${var.azurerm_shared_image_version_object.resource_group_name}"
      GALLERY_NAME="${var.azurerm_shared_image_version_object.gallery_name}"
      IMAGE_DEFINITION="${var.azurerm_shared_image_version_object.image_name}"

      echo "Starting to check if the image $IMAGE_NAME exists in resource group $RESOURCE_GROUP, gallery $GALLERY_NAME, and image definition $IMAGE_DEFINITION..."

      while true; do
        if az sig image-version show \
          --resource-group "$RESOURCE_GROUP" \
          --gallery-name "$GALLERY_NAME" \
          --gallery-image-definition "$IMAGE_DEFINITION" \
          --gallery-image-version "$IMAGE_NAME" &>/dev/null; then
          echo "Image $IMAGE_NAME exists!"
          exit 0
        fi
        echo "Image $IMAGE_NAME does not exist yet. Checking again in 15 minutes..."
        sleep 900
      done
    EOT
  }

  triggers_replace = {
    always_run = var.create_packer_image
  }

  depends_on = [module.az_compute_galley, azurerm_bastion_host.example]
}

## Retrieve the image created by Packer 
## Take a look at /nomad/packer/variables.pkr.hcl for reference

data "azurerm_shared_image_version" "this" {
  name                = var.azurerm_shared_image_version_object.name
  image_name          = var.azurerm_shared_image_version_object.image_name
  gallery_name        = var.azurerm_shared_image_version_object.gallery_name
  resource_group_name = var.azurerm_shared_image_version_object.resource_group_name
  depends_on          = [terraform_data.packer_image]
}

output "name" {

  value = data.azurerm_shared_image_version.this
}