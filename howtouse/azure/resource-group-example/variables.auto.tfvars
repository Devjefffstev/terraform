resource_group_prop_mod = {
  rg-dev-app = {
    location = "eastus"
    tags = {
      environment = "development"
      team        = "app-team"
    }
  }
  rg-prod-app = {
    location = "eastus"
    tags = {
      environment = "production"
      team        = "app-team"
    }
  }
  rg-dev-db = {
    location = "eastus"
  }
  rg-prod-db = {
    location = "eastus"
    tags = {
      environment = "production"
      team        = "db-team"
    }
  }
}
