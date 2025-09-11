# Run terraform test -var-file=tests/vars.auto.testvars from the parent directory
# Subscription ID is automatically read from TF_VAR_subscription_id environment variable

provider "azurerm" { 
  features {}
  subscription_id = var.subscription_id
}
variables {
  apply = false
}

run "plan" {
  command = plan
  plan_options {
    target = [ module.avm-res-network-networksecuritygroup ]
  }
  module {
    source = "./"
  }
  assert {
    condition = length(local.nsg_rules )== 4
    error_message = "Expected 4 default NSG rules, got ${length(local.nsg_rules)}"
  }

}
run "apply" {
  command = plan
  plan_options {
    target = [ module.vmss ]
  }
  module {
    source = "./"
  }
  assert {
    condition = var.apply != true
    error_message = run.plan.network_security_group_prop.name
  }
}