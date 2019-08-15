resource "oci_core_instance" "vm" {
  // availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  availability_domain = "${var.availability_domain}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.vm_display_name}"
  shape               = "${var.compute_shape}"

  create_vnic_details {
    subnet_id        = "${var.untrust_subnet_id}"
    display_name     = "${var.untrust_vnic_display_name}"
    assign_public_ip = "${var.assign_public_ip}"
    hostname_label   = "${var.untrust_vnic_hostname_label}"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.use_marketplace_image ? local.mp_listing_resource_id : var.custom_image_id}"
  }

  //required for metadata setup via cloud-init
  metadata {
    user_data = "${base64encode(data.template_file.bootstrap.rendered)}"
  }

  timeouts {
    create = "60m"
  }
}

data "template_file" "bootstrap" {
  template = "${file("${path.module}/userdata/bootstrap.tpl")}"

  vars {
    vm_display_name       = "${var.vm_display_name}"
    fortigate_license_key = "${var.fortigate_license_key}"
  }
}

resource "oci_core_vnic_attachment" "vnic_attach_trust" {
  instance_id  = "${oci_core_instance.vm.id}"
  display_name = "trust-attach"

  create_vnic_details {
    subnet_id              = "${var.trust_subnet_id}"
    display_name           = "${var.trust_vnic_display_name}"
    assign_public_ip       = false
    skip_source_dest_check = true

    // private_ip             = "${var.trust_primary_private_ip}"  
  }
}

// resource "oci_core_private_ip" "trust_private_ip" {
//   #Get Primary VNIC id
//   vnic_id = "${element(oci_core_vnic_attachment.vnic_attach_trust.*.vnic_id, 0)}"


//   #Optional	
//   display_name   = "trust_floating_ip"
//   hostname_label = "${var.trust_vnic_hostname_label}"
//   // ip_address     = "${var.trust_floating_private_ip}"
// }

