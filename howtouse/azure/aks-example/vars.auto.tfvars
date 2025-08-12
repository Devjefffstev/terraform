location = "eastus2"
name     = "general-services"
default_node_pool = {
  name       = "default"
  node_count = 1
  vm_size    = "Standard_B2s"
}
identity = {
  type = "SystemAssigned"
#   type = "UserAssigned"
  # identity_ids = []
}
