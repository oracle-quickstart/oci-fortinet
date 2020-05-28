output "untrust_routetable_id" {
  value = "${!var.use_existing_network ? join("",oci_core_route_table.untrust_routetable.*.id) : var.untrust_routetable_id}"
}

output "trust_routetable_id" {
  value = "${!var.use_existing_network ? join("",oci_core_route_table.trust_routetable.*.id) : var.trust_routetable_id}"
}

output "untrust_security_list_id" {
  value = "${!var.use_existing_network ? join("",oci_core_security_list.untrust_security_list.*.id) : var.untrust_security_list_id}"
}

output "trust_security_list_id" {
  value = "${!var.use_existing_network ? join("",oci_core_security_list.trust_security_list.*.id) : var.trust_security_list_id}"
}
