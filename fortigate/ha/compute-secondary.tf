resource "oci_core_instance" "secondary_instance" {
  depends_on = [oci_core_app_catalog_subscription.mp_image_subscription]

  availability_domain = local.availability_domain_secondary
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name}-secondary"
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
    hostname_label         = var.hostname_label-secondary
    skip_source_dest_check = false
    assign_public_ip       = local.is_public_mgmt_subnet
    private_ip             = var.mgmt_private_ip-secondary
  }

  source_details {
    source_type = "image"
    source_id   = local.compute_image_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(data.template_file.compute_userdata-secondary.rendered)
  }

  freeform_tags = map(var.tag_key_name, var.tag_value)

}

data "template_file" "compute_userdata-secondary" {
  template = file("./userdata/bootstrap-secondary.tpl")

  vars = {
    hostname     = var.hostname_label-secondary
    mgmt_ip      = var.mgmt_private_ip-secondary
    mgmt_ip_mask = cidrnetmask(data.oci_core_subnet.mgmt_subnet.cidr_block)

    untrust_floating_private_ip      = var.untrust_floating_private_ip
    untrust_floating_private_ip_mask = cidrnetmask(data.oci_core_subnet.untrust_subnet.cidr_block)

    trust_floating_private_ip      = var.trust_floating_private_ip
    trust_floating_private_ip_mask = cidrnetmask(data.oci_core_subnet.trust_subnet.cidr_block)

    ha_ip      = var.ha_private_ip-secondary
    ha_ip_mask = cidrnetmask(data.oci_core_subnet.ha_subnet.cidr_block)
    ha_peer_ip = var.ha_private_ip-primary

    untrust_subnet_gw = cidrhost(data.oci_core_subnet.untrust_subnet.cidr_block, 1)
    trust_subnet_gw   = cidrhost(data.oci_core_subnet.trust_subnet.cidr_block, 1)
    mgmt_subnet_gw    = cidrhost(data.oci_core_subnet.mgmt_subnet.cidr_block, 1)

    vcn_cidr         = data.oci_core_vcn.ha_vcn.cidr_block
    tenancy_ocid     = var.tenancy_ocid
    compartment_ocid = var.compute_compartment_ocid
    region           = var.region

    license_file-secondary = file(var.path_license_file-secondary)
  }
}


//secondary vnics - untrust/trust/ha

resource "oci_core_vnic_attachment" "untrust_vnic_secondary_instance" {
  depends_on = [oci_core_instance.secondary_instance]

  create_vnic_details {
    subnet_id = local.use_existing_network ? var.untrust_subnet_id : oci_core_subnet.untrust_subnet.0.id
    // private_ip             = var.
    display_name           = var.untrust_subnet_display_name
    hostname_label         = var.hostname_label-secondary
    skip_source_dest_check = true
    assign_public_ip       = false
    // nsg_ids                = [oci_core_network_security_group.nsg_untrust.id]
  }

  instance_id = oci_core_instance.secondary_instance.id
}

resource "oci_core_vnic_attachment" "trust_vnic_secondary_instance" {
  depends_on = [oci_core_vnic_attachment.untrust_vnic_secondary_instance]

  create_vnic_details {
    subnet_id = local.use_existing_network ? var.trust_subnet_id : oci_core_subnet.trust_subnet.0.id
    // private_ip             = var.
    display_name           = var.trust_subnet_display_name
    hostname_label         = var.hostname_label-secondary
    skip_source_dest_check = true
    assign_public_ip       = false
    // nsg_ids                = [oci_core_network_security_group.nsg_trust.id]
  }

  instance_id = oci_core_instance.secondary_instance.id
}


resource "oci_core_vnic_attachment" "ha_vnic_secondary_instance" {
  depends_on = [oci_core_vnic_attachment.trust_vnic_secondary_instance]
  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.ha_subnet_id : oci_core_subnet.ha_subnet.0.id
    display_name           = var.ha_subnet_display_name
    hostname_label         = var.hostname_label-secondary
    skip_source_dest_check = true
    assign_public_ip       = false
    private_ip             = var.ha_private_ip-secondary
  }

  instance_id = oci_core_instance.secondary_instance.id
}

data "oci_core_vnic" "trust_vnic_secondary_instance" {
  vnic_id = oci_core_vnic_attachment.trust_vnic_secondary_instance.vnic_id
}

data "oci_core_vnic" "untrust_vnic_secondary_instance" {
  #Required
  vnic_id = oci_core_vnic_attachment.trust_vnic_secondary_instance.vnic_id
}

data "oci_core_vnic" "ha_vnic_secondary_instance" {
  #Required
  vnic_id = oci_core_vnic_attachment.ha_vnic_secondary_instance.vnic_id
}

data "oci_core_private_ips" "trust_vnic_private_ips_secondary_instance" {
  vnic_id = oci_core_vnic_attachment.trust_vnic_secondary_instance.vnic_id
}

data "oci_core_private_ips" "untrust_vnic_private_ips_secondary_instance" {
  vnic_id = oci_core_vnic_attachment.untrust_vnic_secondary_instance.vnic_id
}

data "oci_core_private_ips" "ha_vnic_private_ips_secondary_instance" {
  vnic_id = oci_core_vnic_attachment.ha_vnic_secondary_instance.vnic_id
}
