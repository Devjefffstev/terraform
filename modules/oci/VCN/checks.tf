
check "vcn" {
  assert {
    condition     = length(oci_core_vcn.main[*]) == 1
    error_message = "https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/Overview_of_VCNs_and_Subnets.htm#vcn-subnet-limits"
  }
  assert {
    condition     = length(var.cidr_blocks) <= 5
    error_message = "https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/Overview_of_VCNs_and_Subnets.htm#vcn-subnet-limits"
  }
}
check "subnets" {
  assert {
    condition     = length(oci_core_subnet.main[*]) <= 300
    error_message = "https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/Overview_of_VCNs_and_Subnets.htm#vcn-subnet-limits"
  }
}
