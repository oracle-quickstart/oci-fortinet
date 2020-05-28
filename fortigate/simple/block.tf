resource "oci_core_volume" "vm_block_volume" {
  availability_domain = local.availability_domain
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name}-bv"
  size_in_gbs         = var.vm_block_volume_size
}

resource "oci_core_volume_attachment" "vm_volume_attach" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.simple.id
  volume_id       = oci_core_volume.vm_block_volume.id
}