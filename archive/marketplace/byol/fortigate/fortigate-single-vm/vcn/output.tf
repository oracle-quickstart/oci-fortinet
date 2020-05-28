output "vcn_id" {
  value = "${!var.use_existing_network ? join("",oci_core_vcn.vcn.*.id) : var.vcn_id}"
}

output "default_dhcp_options_id" {
  value = "${!var.use_existing_network ? join("",oci_core_vcn.vcn.*.default_dhcp_options_id) : var.default_dhcp_options_id}"
}

output "default_security_list_id" {
  value = "${!var.use_existing_network ? join("",oci_core_vcn.vcn.*.default_security_list_id) : var.default_security_list_id}"
}
