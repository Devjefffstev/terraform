locals {
  subnets = {
    for subnet_key, subnet in var.subnets : subnet_key => merge(subnet, {
      display_name  = subnet_key
      comparment_id = var.compartment_id
      vcn_id        = oci_core_vcn.main.id
      }
    )
  }
}
