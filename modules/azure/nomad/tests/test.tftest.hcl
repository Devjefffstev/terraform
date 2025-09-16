# Run terraform test -var-file=tests/vars.auto.testvars from the parent directory
# Subscription ID is automatically read from TF_VAR_subscription_id environment variable
# Add this at the beginning of your test file

# variable "subscription_id" {
#   type        = string
#   description = "The Azure subscription ID for testing"
# }
# provider "azurerm" {
#   features {}
#   subscription_id = var.subscription_id
# }

mock_provider "azurerm" {
  alias = "fake"
  mock_resource "azurerm_subnet" {
    defaults = {
      id = "/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/rg-nomad-test-001/providers/Microsoft.Network/virtualNetworks/MyVNet/subnets/MySubnet"
    }
  }
  mock_resource "azurerm_shared_image_version" {
    defaults = {
      id = "/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/rg-my-image-build/providers/Microsoft.Compute/images/ubuntu-custom-image2"
    }
  }

}

variables {
  # resource_group_name = run.apply_infra_pre_req.resource_group_name
  # location            = run.apply_infra_pre_req.resource_group_location
  os_profile = {
    custom_data = base64encode(file("tests/custom-data.yaml"))
    linux_configuration = {
      disable_password_authentication = false
      # user_data_base64                = "user-data-server.sh"   
      admin_username   = "azureuser"
      patch_mode       = "ImageDefault"
      user_data_base64 = base64encode(file("tests/user-data-client.sh"))
    }
  }
  network_interface = [
    {
      name = "VMSS-NIC"
      ip_configuration = [{
        name = "VMSS-IPConfig"
        # subnet_id = run.apply_infra_pre_req.subnet_id
        subnet_id = "/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/rg-nomad-test-001/providers/Microsoft.Network/virtualNetworks/MyVNet/subnets/MySubnet"
      }]
    }
  ]
  source_image_id = "/subscriptions/4ccb67b6-0e4c-45c5-88bf-ba71125163e1/resourceGroups/rg-my-image-build/providers/Microsoft.Compute/images/ubuntu-custom-image"

  ## variables for VM avm module



}

# run "apply_infra_pre_req" {
#   command = apply


#   module {
#     source = "./tests/infra_pre_req"
#   }
# }

run "plan" {
  providers = {
    azurerm = azurerm.fake
  }
  command = plan

  module {
    source = "./"
  }

}

run "apply" {
  providers = {
    azurerm = azurerm.fake
  }

  override_module {
    target = module.avm_res_network_networksecuritygroup
    outputs = {
      resource_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/networkSecurityGroups/networkSecurityGroupName"
    }
  }
  override_module {
    target = module.vmss
    outputs = {
      resource_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachineScaleSets/my-vmss"
    }
  }
  override_module {
    target = module.avm_res_compute_virtualmachine
    outputs = {
      admin_generated_ssh_private_key = "hardcoded-ssh-private-key"
      admin_password                  = "hardcoded-admin-password"
      admin_ssh_keys                  = ["ssh-rsa AAAAB3... hardcoded-key"]
      admin_username                  = "hardcoded-admin-user"
      network_interfaces = {
        network_interface_1 = {
          name = "vm-nomad-client-eus-sbx-nic"
          ip_configurations = {
            ip_configuration_1 = {
              name                          = "vm-nomad-client-eus-sbx-ipconfig"
              private_ip_subnet_resource_id = "/subscriptions/ae8fb469-4dad-482c-80e7-00bde08748b1/resourceGroups/rg-nomad-eus-sbx/providers/Microsoft.Network/virtualNetworks/vnet-nomad-eus-sbx/subnets/default"
              create_public_ip_address      = true
              public_ip_address_name        = "vm-nomad-client-eus-sbx-pip"
            }
          }
          network_security_groups = {
            network_interface_1 = {
              network_security_group_resource_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/networkSecurityGroups/networkSecurityGroupName"
            }
          }
        }
      }
    }
  }
  module {
    source = "./"
  }


}
# run "apply_real" {
#   command = apply
#   providers = {
#     azurerm = azurerm
#   }  
#   module {
#     source = "./"
#   }


# }

