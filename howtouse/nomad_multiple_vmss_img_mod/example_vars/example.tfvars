vmss_config_map = {
  example_vmss = {
    resource_group_name = "rg-nomad-one-of-two"
    location            = "East US"
    vmss_name           = "vmss-nomad-one-of-two"
    enable_telemetry    = false
    extension = [{
      name                        = "HealthExtension"
      publisher                   = "Microsoft.ManagedServices"
      type                        = "ApplicationHealthLinux"
      type_handler_version        = "1.0"
      auto_upgrade_minor_version_enabled  = true
      failure_suppression_enabled = false
      settings                    = "{\"port\":80,\"protocol\":\"http\",\"requestPath\":\"/index.html\"}"   
    }]
    instances = 2
    network_interface = [{
      name = "VMSS-NIC"      
      ip_configuration = [{
        name = "VMSS-IPConfig"      
      }]
    }]
    os_profile = {
      custom_data = "custom-data.yaml"
      linux_configuration = {
        disable_password_authentication = false
        user_data_base64                = "user-data-server.sh"
        admin_username                  = "azureuser"
        patch_mode                      = "ImageDefault"
      }
    }
    sku_name       = "Standard_B1s"
    admin_password = "aziresdf324#@!"
    tags = {
      environment     = "dev"
      type            = "nomad"
      applicationRole = "server"
      ConsulAutoJoin  = "auto-join"
    }
    image_galleries = {
      "acgnomadtwo" = {
        shared_image_definitions = [{
          name               = "nomad"
          hyper_v_generation = "V2"
          os_type            = "Linux"
          identifier = {
            publisher = "Canonical"
            offer     = "0001-com-ubuntu-server-jammy"
            sku       = "22_04-lts-gen2"
          }
          purchase_plan = {
            name      = "22_04-lts-gen2"
            publisher = "Canonical"
            product   = "0001-com-ubuntu-server-jammy"
          }
          image_version = [
            {
              image_name = "0.0.1"          
              target_region = {
                name                   = "East US"
                regional_replica_count = 1
                storage_account_type   = "Standard_LRS"
              }
            },
            {
              image_name = "0.0.2"
              create_vmss_with_this_image = true
              target_region = {
                name                   = "East US"
                regional_replica_count = 1
                storage_account_type   = "Standard_LRS"
              }
            }
          ]
        }]
      }    
      "acgnginx" = {
        shared_image_definitions = [{
          name               = "nginx"
          hyper_v_generation = "V2"
          os_type            = "Linux"
          identifier = {
            publisher = "Canonical"
            offer     = "0001-com-ubuntu-server-jammy"
            sku       = "22_04-lts-gen2"
          }
          purchase_plan = {
            name      = "22_04-lts-gen2"
            publisher = "Canonical"
            product   = "0001-com-ubuntu-server-jammy"
          }
          image_version = [
            {
              image_name = "0.0.1"          
              target_region = {
                name                   = "East US"
                regional_replica_count = 1
                storage_account_type   = "Standard_LRS"
              }
            },
            {
              image_name = "0.0.2"
              create_vmss_with_this_image = true
              target_region = {
                name                   = "East US"
                regional_replica_count = 1
                storage_account_type   = "Standard_LRS"
              }
            }
          ]
        }]
      }    
    }
  }
  only_vmss = {
    resource_group_name = "rg-nomad-two-of-two"
    location            = "East US"
    vmss_name           = "vmss-nomad-two-of-two"
    enable_telemetry    = false
    extension = [{
      name                        = "HealthExtension"
      publisher                   = "Microsoft.ManagedServices"
      type                        = "ApplicationHealthLinux"
      type_handler_version        = "1.0"
      auto_upgrade_minor_version_enabled  = true
      failure_suppression_enabled = false
      settings                    = "{\"port\":80,\"protocol\":\"http\",\"requestPath\":\"/index.html\"}"   
    }]
    instances = 2
    network_interface = [{
      name = "VMSS-NIC"      
      ip_configuration = [{
        name = "VMSS-IPConfig"      
      }]
    }]
    os_profile = {
      custom_data = "custom-data.yaml"
      linux_configuration = {
        disable_password_authentication = false
        user_data_base64                = "user-data-server.sh"
        admin_username                  = "azureuser"
        patch_mode                      = "ImageDefault"
      }
    }
    sku_name       = "Standard_B1s"
    admin_password = "aziresdf324#@!"
    tags = {
      environment     = "dev"
      type            = "nomad"
      applicationRole = "server"
      ConsulAutoJoin  = "auto-join"
    }
  }
 ## It must exist the gallery and the image inside it.
 ## To run this you must uncomment this block once the gallery and image are created. 
  reading_image_on_existing_gallery = {
    resource_group_name = "rg-nomad-reading-image"
    location            = "East US"
    vmss_name           = "vmss-nomad-reading-image"
    enable_telemetry    = false
    extension = [{
      name                        = "HealthExtension"
      publisher                   = "Microsoft.ManagedServices"
      type                        = "ApplicationHealthLinux"
      type_handler_version        = "1.0"
      auto_upgrade_minor_version_enabled  = true
      failure_suppression_enabled = false
      settings                    = "{\"port\":80,\"protocol\":\"http\",\"requestPath\":\"/index.html\"}"   
    }]
    instances = 2
    network_interface = [{
      name = "VMSS-NIC"      
      ip_configuration = [{
        name = "VMSS-IPConfig"      
      }]
    }]
    os_profile = {
      custom_data = "custom-data.yaml"
      linux_configuration = {
        disable_password_authentication = false
        user_data_base64                = "user-data-server.sh"
        admin_username                  = "azureuser"
        patch_mode                      = "ImageDefault"
      }
    }
    sku_name       = "Standard_B1s"
    admin_password = "aziresdf324#@!"
    tags = {
      environment     = "dev"
      type            = "nomad"
      applicationRole = "server"
      ConsulAutoJoin  = "auto-join"
    }
    image_already_created = {
  gallery_name                             = "acgnomadtwo"
  resource_group_name                      = "rg-nomad-one-of-two"
      image_definition = "nomad"
      image_name = "0.0.2"
    }
  }
}