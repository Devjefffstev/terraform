check "amount_of_galleries" {
  assert {
    condition     = length(keys(var.image_galleries)) >= 1
    error_message = "Please be sure to define at least one Shared Image Gallery in the variable image_galleries"
  }

}
check "vmss_variables" {
  assert {
    condition     = var.resource_group_name != null || var.location != null
    error_message = "Please be sure to define at least one VMSS in the variables"
  }
}