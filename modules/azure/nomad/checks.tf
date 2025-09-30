
check "vmss_variables" {
  assert {
    condition     = var.resource_group_name != null || var.location != null
    error_message = "Please be sure to define at least one VMSS in the variables"
  }
}