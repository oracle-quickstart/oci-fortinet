resource "oci_core_volume" "vm_volume" {
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.block_volume_display_name}"
  size_in_gbs         = "${var.block_volume_size}"
}

resource "oci_core_volume_attachment" "vm_volume_attach" {
  attachment_type = "paravirtualized"
  instance_id     = "${oci_core_instance.vm.id}"
  volume_id       = "${oci_core_volume.vm_volume.id}"
}
