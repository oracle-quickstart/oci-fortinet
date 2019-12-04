resource "oci_core_volume" "vm_volume" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "vm_volume"
  size_in_gbs         = "${var.volume_size}"
}

resource "oci_core_volume_attachment" "vm_volume_attach" {
  attachment_type = "paravirtualized"
  //compartment_id  = "${var.compartment_ocid}"
  instance_id     = "${oci_core_instance.vm.id}"
  volume_id       = "${oci_core_volume.vm_volume.id}"
}
