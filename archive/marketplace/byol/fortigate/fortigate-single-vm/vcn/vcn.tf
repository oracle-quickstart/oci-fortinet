resource "oci_core_vcn" "vcn" {
  count          = "${var.use_existing_network ? 0:1}"
  cidr_block     = "${var.vcn_cidr_block}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.vcn_display_name}"
  dns_label      = "${var.vcn_dns_label}"
}
