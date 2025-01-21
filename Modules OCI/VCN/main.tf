resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id
  cidr_blocks    = var.cidr_blocks
  display_name   = var.display_name
  
}

resource "oci_core_subnet" "main" {
  for_each       = local.subnets
  compartment_id = each.value.comparment_id
  vcn_id         = each.value.vcn_id
  display_name   = each.value.display_name
  cidr_block     = each.value.cidr_block
  dns_label      = try(each.value.dns_label, null)
}


