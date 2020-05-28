// data "template_file" "bootstrap" {
//   template = file("${path.module}/userdata/bootstrap.tpl")

//   vars {
//     vm_display_name  = var.vm_display_name
//     vm_license_key   = var.vm_license_key
//   }
// }

resource "oci_core_instance" "simple" {
  depends_on = [oci_core_app_catalog_subscription.mp_image_subscription]

  availability_domain = local.availability_domain
  compartment_id      = var.compute_compartment_ocid
  display_name        = var.vm_display_name
  shape               = var.vm_compute_shape

  dynamic "shape_config" {
    for_each = local.is_flex_shape
    content {
      ocpus = shape_config.value
    }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.mgmt_subnet_id : oci_core_subnet.simple_mgmt_subnet[0].id
    display_name           = var.mgmt_subnet_display_name
    hostname_label         = var.hostname_label
    skip_source_dest_check = false
    assign_public_ip       = local.is_public_mgmt_subnet
    nsg_ids                = [oci_core_network_security_group.simple_nsg_mgmt.id]
  }

  source_details {
    source_type = "image"
    source_id   = local.compute_image_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(templatefile("./fortigate_license.tpl", { vm_display_name = var.vm_display_name, vm_license_key = var.vm_license_key }))
  }

  freeform_tags = map(var.tag_key_name, var.tag_value)

}


//secondary vnics - wan/lan
resource "oci_core_vnic_attachment" "simple_wan_vnic" {
  depends_on = [oci_core_instance.simple]
  create_vnic_details {
    subnet_id = local.use_existing_network ? var.wan_subnet_id : oci_core_subnet.simple_wan_subnet.0.id
    // private_ip             = var.
    display_name           = var.wan_subnet_display_name
    hostname_label         = var.hostname_label
    skip_source_dest_check = true
    assign_public_ip       = false
    // nsg_ids                = [oci_core_network_security_group.simple_nsg_wan.id]
  }

  instance_id = oci_core_instance.simple.id
}


resource "oci_core_vnic_attachment" "simple_lan_vnic" {
  depends_on = [oci_core_vnic_attachment.simple_wan_vnic]
  create_vnic_details {
    subnet_id = local.use_existing_network ? var.lan_subnet_id : oci_core_subnet.simple_lan_subnet.0.id
    // private_ip             = var.
    display_name           = var.lan_subnet_display_name
    hostname_label         = var.hostname_label
    skip_source_dest_check = true
    assign_public_ip       = false
    // nsg_ids                = [oci_core_network_security_group.simple_nsg_lan.id]
  }

  instance_id = oci_core_instance.simple.id
}

// data "oci_core_vnic" "simple_wan_vnic" {
//   vnic_id = "${oci_core_vnic_attachment.simple_wan_vnic.vnic_id}"
// }

// data "oci_core_vnic" "simple_lan_vnic" {
//   vnic_id = "${oci_core_vnic_attachment.simple_lan_vnic.vnic_id}"
// }

data "oci_core_private_ips" "simple_wan_vnic_private_ips" {
  vnic_id = oci_core_vnic_attachment.simple_wan_vnic.vnic_id
}

data "oci_core_private_ips" "simple_lan_vnic_private_ips" {
  vnic_id = oci_core_vnic_attachment.simple_lan_vnic.vnic_id
}

resource "oci_core_public_ip" "wan_reserved_public_ip" {
  count          = local.is_public_wan_subnet && local.is_public_wan_subnet ? 1 : 0
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.vm_display_name}_wan"
  lifetime       = "RESERVED"
  private_ip_id  = lookup(data.oci_core_private_ips.simple_wan_vnic_private_ips.private_ips[0], "id")
  freeform_tags  = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_public_ip" "lan_reserved_public_ip" {
  count          = local.is_public_lan_subnet && local.is_public_lan_subnet ? 1 : 0
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.vm_display_name}_lan"
  lifetime       = "RESERVED"
  private_ip_id  = lookup(data.oci_core_private_ips.simple_lan_vnic_private_ips.private_ips[0], "id")
  freeform_tags  = map(var.tag_key_name, var.tag_value)
}
