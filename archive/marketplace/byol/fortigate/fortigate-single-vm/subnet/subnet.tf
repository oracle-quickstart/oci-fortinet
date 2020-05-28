resource "oci_core_subnet" "subnet" {
  count                      = "${var.use_existing_network ? 0:1}"
  availability_domain        = "${var.availability_domain != "" ? var.availability_domain : ""}"
  vcn_id                     = "${var.vcn_id}"
  cidr_block                 = "${var.cidr_block}"
  display_name               = "${var.display_name}"
  compartment_id             = "${var.compartment_ocid}"
  route_table_id             = "${var.route_table_id}"
  security_list_ids          = ["${var.security_list_ids}"]
  dhcp_options_id            = "${var.dhcp_options_id}"
  dns_label                  = "${var.dns_label}"
  prohibit_public_ip_on_vnic = "${!var.allow_public_ip}"
}
