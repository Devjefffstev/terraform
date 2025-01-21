output "vcn_properties" {
  value       = oci_core_vcn.main
  description = "Export the VCN properties"
}
output "subnets_properties" {
  value       = oci_core_subnet.main
  description = "Export the Subnets properties"
}
output "subnets_cidr_block" {
  value       = { for key, subnet in oci_core_subnet.main : key => subnet.cidr_block }
  description = "Export the Subnets cidr_block"
}
output "vcn_cidr_amount" {
  value       = length(oci_core_vcn.main.cidr_block)
  description = "Export the Subnets cidr_block"
}
