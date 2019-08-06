# Gets a list of Availability Domains

// data "oci_identity_availability_domain" "ad" {
//   compartment_id = "${var.tenancy_ocid}"
//   ad_number      = "${var.availability_domain}"
// }

# Gets the boot volume attachments for each instance
data "oci_core_boot_volume_attachments" "block_attach" {
  depends_on          = ["oci_core_instance.vm"]
  availability_domain = "${oci_core_instance.vm.0.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  instance_id         = "${oci_core_instance.vm.id}"
}

# Gets a list of vNIC attachments on the instance
data "oci_core_vnic_attachments" "InstanceVnics" {
  compartment_id      = "${var.compartment_ocid}"
  // availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  availability_domain = "${var.availability_domain}"
  instance_id         = "${oci_core_instance.vm.id}"
}

# Gets the OCID of the Primary vNIC
data "oci_core_vnic" "InstanceVnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.InstanceVnics.vnic_attachments[0],"vnic_id")}"
}
