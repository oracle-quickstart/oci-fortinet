# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = "${var.tenancy_ocid}"
}

# Gets the boot volume attachments for each instance
data "oci_core_boot_volume_attachments" "block_attach-a" {
  depends_on          = ["oci_core_instance.vm-a"]
  availability_domain = "${oci_core_instance.vm-a.0.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  instance_id         = "${oci_core_instance.vm-a.id}"
}

data "oci_core_boot_volume_attachments" "block_attach-b" {
  depends_on          = ["oci_core_instance.vm-b"]
  availability_domain = "${oci_core_instance.vm-b.0.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  instance_id         = "${oci_core_instance.vm-b.id}"
}
