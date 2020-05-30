resource "oci_core_instance" "primary_instance" {
  depends_on = [oci_core_app_catalog_subscription.mp_image_subscription]

  availability_domain = local.availability_domain_primary
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name}-primary"
  shape               = var.vm_compute_shape

  dynamic "shape_config" {
    for_each = local.is_flex_shape
    content {
      ocpus = shape_config.value
    }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.mgmt_subnet_id : oci_core_subnet.mgmt_subnet[0].id
    display_name           = var.mgmt_subnet_display_name
    hostname_label         = var.hostname_label-primary
    skip_source_dest_check = false
    assign_public_ip       = local.is_public_mgmt_subnet
    private_ip             = var.mgmt_private_ip-primary
  }

  source_details {
    source_type = "image"
    source_id   = local.compute_image_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(data.template_file.compute_userdata-primary.rendered)
  }

  freeform_tags = map(var.tag_key_name, var.tag_value)

}

data "template_file" "compute_userdata-primary" {
  template = file("./userdata/bootstrap-primary.tpl")

  vars = {
    hostname     = var.hostname_label-primary
    mgmt_ip      = var.mgmt_private_ip-primary
    mgmt_ip_mask = cidrnetmask(data.oci_core_subnet.mgmt_subnet.cidr_block)

    untrust_floating_private_ip      = var.untrust_floating_private_ip
    untrust_floating_private_ip_mask = cidrnetmask(data.oci_core_subnet.untrust_subnet.cidr_block)

    trust_floating_private_ip      = var.trust_floating_private_ip
    trust_floating_private_ip_mask = cidrnetmask(data.oci_core_subnet.trust_subnet.cidr_block)

    ha_ip      = var.ha_private_ip-primary
    ha_ip_mask = cidrnetmask(data.oci_core_subnet.ha_subnet.cidr_block)
    ha_peer_ip = var.ha_private_ip-secondary

    untrust_subnet_gw = cidrhost(data.oci_core_subnet.untrust_subnet.cidr_block, 1)
    trust_subnet_gw   = cidrhost(data.oci_core_subnet.trust_subnet.cidr_block, 1)
    mgmt_subnet_gw    = cidrhost(data.oci_core_subnet.mgmt_subnet.cidr_block, 1)

    vcn_cidr         = data.oci_core_vcn.ha_vcn.cidr_block
    tenancy_ocid     = var.tenancy_ocid
    compartment_ocid = var.compute_compartment_ocid
    region           = var.region

    license_file-primary = file(var.path_license_file-primary)
  }
}


//secondary vnics - untrust/trust/ha

resource "oci_core_vnic_attachment" "untrust_vnic_primary_instance" {
  depends_on = [oci_core_instance.primary_instance]

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.untrust_subnet_id : oci_core_subnet.untrust_subnet.0.id
    display_name           = var.untrust_subnet_display_name
    hostname_label         = var.hostname_label-primary
    skip_source_dest_check = true
    assign_public_ip       = false
  }

  instance_id = oci_core_instance.primary_instance.id
}

resource "oci_core_vnic_attachment" "trust_vnic_primary_instance" {
  depends_on = [oci_core_vnic_attachment.untrust_vnic_primary_instance]

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.trust_subnet_id : oci_core_subnet.trust_subnet.0.id
    display_name           = var.trust_subnet_display_name
    hostname_label         = var.hostname_label-primary
    skip_source_dest_check = true
    assign_public_ip       = false
  }

  instance_id = oci_core_instance.primary_instance.id
}



resource "oci_core_vnic_attachment" "ha_vnic_primary_instance" {
  depends_on = [oci_core_vnic_attachment.trust_vnic_primary_instance]
  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.ha_subnet_id : oci_core_subnet.ha_subnet.0.id
    private_ip             = var.ha_private_ip-primary
    display_name           = var.ha_subnet_display_name
    hostname_label         = var.hostname_label-primary
    skip_source_dest_check = true
    assign_public_ip       = false
  }

  instance_id = oci_core_instance.primary_instance.id
}

data "oci_core_vnic" "trust_vnic_primary_instance" {
  vnic_id = oci_core_vnic_attachment.trust_vnic_primary_instance.vnic_id
}

data "oci_core_vnic" "untrust_vnic_primary_instance" {
  #Required
  vnic_id = oci_core_vnic_attachment.trust_vnic_primary_instance.vnic_id
}

data "oci_core_vnic" "ha_vnic_primary_instance" {
  #Required
  vnic_id = oci_core_vnic_attachment.ha_vnic_primary_instance.vnic_id
}

data "oci_core_private_ips" "trust_vnic_private_ips_primary_instance" {
  vnic_id = oci_core_vnic_attachment.trust_vnic_primary_instance.vnic_id
}

data "oci_core_private_ips" "untrust_vnic_private_ips_primary_instance" {
  vnic_id = oci_core_vnic_attachment.untrust_vnic_primary_instance.vnic_id
}

data "oci_core_private_ips" "ha_vnic_private_ips_primary_instance" {
  vnic_id = oci_core_vnic_attachment.ha_vnic_primary_instance.vnic_id
}


### Resources only required in the primary instance

//trust secondary ip
resource "oci_core_private_ip" "trust_floating_ip" {
  #Required
  vnic_id = oci_core_vnic_attachment.trust_vnic_primary_instance.vnic_id

  #Optional
  display_name   = var.trust_subnet_display_name
  hostname_label = var.hostname_label
  freeform_tags  = map(var.tag_key_name, var.tag_value)
  ip_address     = var.trust_floating_private_ip
}

//untrust secondary ip
resource "oci_core_private_ip" "untrust_floating_ip" {
  #Required
  vnic_id = oci_core_vnic_attachment.untrust_vnic_primary_instance.vnic_id

  #Optional
  display_name   = var.untrust_subnet_display_name
  hostname_label = var.hostname_label
  freeform_tags  = map(var.tag_key_name, var.tag_value)
  ip_address     = var.untrust_floating_private_ip
}


//trust public ip
resource "oci_core_public_ip" "trust_reserved_public_ip" {
  count          = local.is_public_trust_subnet && local.is_public_trust_subnet ? 1 : 0
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.vm_display_name}_trust"
  lifetime       = "RESERVED"
  // private_ip_id  = lookup(data.oci_core_private_ips.trust_vnic_private_ips.private_ips[0], "id")
  private_ip_id = oci_core_private_ip.trust_floating_ip.id
  freeform_tags = map(var.tag_key_name, var.tag_value)
}




resource "oci_core_public_ip" "untrust_reserved_public_ip" {
  count          = local.is_public_untrust_subnet && local.is_public_untrust_subnet ? 1 : 0
  compartment_id = var.network_compartment_ocid
  display_name   = "${var.vm_display_name}_untrust"
  lifetime       = "RESERVED"
  // private_ip_id  = lookup(data.oci_core_private_ips.untrust_vnic_private_ips.private_ips[0], "id")
  private_ip_id = oci_core_private_ip.untrust_floating_ip.id
  freeform_tags = map(var.tag_key_name, var.tag_value)
}


// data "oci_core_vnic" "trust_vnic" {
//   vnic_id = "${oci_core_vnic_attachment.trust_vnic.vnic_id}"
// }

// data "oci_core_vnic" "untrust_vnic" {
//   vnic_id = "${oci_core_vnic_attachment.untrust_vnic.vnic_id}"
// }
