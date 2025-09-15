# Required Variables

# Azure region where the resource should be deployed
location = "East US"

# Name of the Shared Image Gallery
name = "myimagegallery"

# Resource group name
# resource_group_name = "my-resource-group"

# Optional Variables

# Enable telemetry (true or false)
enable_telemetry = false


# Shared image definitions
 shared_image_definitions = {
    img01 = {
      name    = "lin-image"
      os_type = "Linux"
      identifier = {
        publisher = "RedHat"
        offer     = "RHEL"
        sku       = "810-gen2"
      }
    }
    img02 = {
      name    = "win-image"
      os_type = "Windows"
      identifier = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-datacenter-gensecond"
      }
    }
  }

# Tags for resources
tags = {
  environment = "dev"
  project     = "compute-gallery"
}

# Timeout settings
timeouts = {
  create = "30m"
  delete = "15m"
  read   = "10m"
  update = "20m"
}