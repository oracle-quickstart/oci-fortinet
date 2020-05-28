# Gets the boot volume attachments for each instance
data "oci_core_boot_volume_attachments" "block_attach" {
  depends_on          = ["oci_core_instance.vm"]
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  instance_id         = "${oci_core_instance.vm.id}"
}

# Gets a list of vNIC attachments on the instance
data "oci_core_vnic_attachments" "instance_vnics" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${var.availability_domain}"
  instance_id         = "${oci_core_instance.vm.id}"
}

data "oci_core_instance" "vm" {
  instance_id = "${oci_core_instance.vm.id}"
}
