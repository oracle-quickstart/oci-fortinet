resource "oci_core_volume" "vm_volume-a" {
  count = 1
  availability_domain = ( var.availability_domain_name != "" ? var.availability_domain_name : ( length(data.oci_identity_availability_domains.ads.availability_domains) == 1 ? data.oci_identity_availability_domains.ads.availability_domains[0].name : data.oci_identity_availability_domains.ads.availability_domains[count.index].name))
  compartment_id      = var.compute_compartment_ocid
  display_name        = "vm_volume-a"
  size_in_gbs         = var.volume_size
}

resource "oci_core_volume_attachment" "vm_volume_attach-a" {
  count = 1
  attachment_type = "paravirtualized"
  instance_id  = oci_core_instance.vm-a[count.index].id
  volume_id       = oci_core_volume.vm_volume-a[count.index].id
}


resource "oci_core_volume" "vm_volume-b" {
  count = 1
  availability_domain = ( var.availability_domain_name != "" ? var.availability_domain_name : ( length(data.oci_identity_availability_domains.ads.availability_domains) == 1 ? data.oci_identity_availability_domains.ads.availability_domains[0].name : data.oci_identity_availability_domains.ads.availability_domains[count.index].name))
  compartment_id      = var.compute_compartment_ocid
  display_name        = "vm_volume-b"
  size_in_gbs         = var.volume_size
}

resource "oci_core_volume_attachment" "vm_volume_attach-b" {
  count = 1
  attachment_type = "paravirtualized"
  instance_id  = oci_core_instance.vm-b[count.index].id
  volume_id       = oci_core_volume.vm_volume-b[count.index].id
}