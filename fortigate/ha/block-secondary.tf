resource "oci_core_volume" "vm_block_volume_secondary_instance" {
  availability_domain = local.availability_domain_secondary
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name}-bv"
  size_in_gbs         = var.vm_block_volume_size
}

resource "oci_core_volume_attachment" "vm_volume_attach_secondary_instance" {
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.secondary_instance.id
  volume_id       = oci_core_volume.vm_block_volume_secondary_instance.id
}

