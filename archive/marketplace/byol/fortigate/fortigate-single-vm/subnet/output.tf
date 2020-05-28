output "subnet_id" {
  value = "${!var.use_existing_network ? join("", oci_core_subnet.subnet.*.id) : var.subnet_id}"
}
