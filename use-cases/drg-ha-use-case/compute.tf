# ------ Create FortiGate Primary VM
resource "oci_core_instance" "vm-a" {
  count = 1
  availability_domain = ( var.availability_domain_name != "" ? var.availability_domain_name : ( length(data.oci_identity_availability_domains.ads.availability_domains) == 1 ? data.oci_identity_availability_domains.ads.availability_domains[0].name : data.oci_identity_availability_domains.ads.availability_domains[count.index].name))
  compartment_id      = var.compute_compartment_ocid
  display_name        = "FortiGate-Primary-Firewall"
  shape               = var.vm_compute_shape

  create_vnic_details {
    subnet_id        = local.use_existing_network ? var.mangement_subnet_id : oci_core_subnet.mangement_subnet[0].id
    display_name     = "vm-a"
    assign_public_ip = true
    hostname_label   = "vma"
    private_ip       = var.mgmt_private_ip_primary_a
  }

  source_details {
    source_type = "image"
    source_id   = local.listing_resource_id
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(data.template_file.vm-a_userdata.rendered)
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_vnic_attachment" "vnic_attach_untrust_a" {
  count = 1
  depends_on   = [oci_core_instance.vm-a]
  instance_id  = oci_core_instance.vm-a[count.index].id
  display_name = "vnic_untrust_a"

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.untrust_subnet_id : oci_core_subnet.untrust_subnet[0].id
    display_name           = "vnic_untrust_a"
    assign_public_ip       = false
    skip_source_dest_check = false
    private_ip             = var.untrust_private_ip_primary_a
  }
}


resource "oci_core_vnic_attachment" "vnic_attach_trust_a" {
  depends_on   = [oci_core_vnic_attachment.vnic_attach_untrust_a]
  count = 1
  instance_id  = oci_core_instance.vm-a[count.index].id
  display_name = "vnic_trust"

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.trust_subnet_id : oci_core_subnet.trust_subnet[0].id
    display_name           = "vnic_trust_a"
    assign_public_ip       = false
    skip_source_dest_check = true
    private_ip             = var.trust_private_ip_primary_a
  }
}

resource "oci_core_vnic_attachment" "vnic_attach_hb_a" {
  depends_on   = [oci_core_vnic_attachment.vnic_attach_trust_a]
  count = 1
  instance_id  = oci_core_instance.vm-a[count.index].id
  display_name = "vnic_hb_a"

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.ha_subnet_id : oci_core_subnet.ha_subnet[0].id
    display_name           = "vnic_hb_a"
    assign_public_ip       = false
    skip_source_dest_check = false
    private_ip             = var.hb_private_ip_primary_a
  }
}

resource "oci_core_private_ip" "untrust_private_ip" {
  vnic_id      = data.oci_core_vnic_attachments.untrust_attachments.vnic_attachments.0.vnic_id
  display_name   = "untrust_ip"
  hostname_label = "untrust"
  ip_address     = var.untrust_floating_private_ip
}

resource "oci_core_public_ip" "untrust_public_ip" {
  compartment_id = var.compute_compartment_ocid
  lifetime       = var.untrust_public_ip_lifetime
  display_name   = "vm-untrust"
  private_ip_id  = oci_core_private_ip.untrust_private_ip.id
}

resource "oci_core_private_ip" "trust_private_ip" {
  vnic_id      = data.oci_core_vnic_attachments.trust_attachments.vnic_attachments.0.vnic_id
  display_name   = "trust_ip"
  hostname_label = "trust"
  ip_address     = var.trust_floating_private_ip
}

data "template_file" "vm-a_userdata" {
  template = file(var.bootstrap_vm-a)
  vars = {
    mgmt_ip                          = var.mgmt_private_ip_primary_a
    mgmt_ip_mask                     = "255.255.255.0"
    untrust_ip                       = var.untrust_private_ip_primary_a
    untrust_ip_mask                  = "255.255.255.0"
    trust_ip                         = var.trust_private_ip_primary_a
    trust_ip_mask                    = "255.255.255.0"
    hb_ip                            = var.hb_private_ip_primary_a
    hb_ip_mask                       = "255.255.255.0"
    hb_peer_ip                       = var.hb_private_ip_primary_b
    untrust_floating_private_ip      = var.untrust_floating_private_ip
    untrust_floating_private_ip_mask = "255.255.255.0"
    trust_floating_private_ip        = var.trust_floating_private_ip
    trust_floating_private_ip_mask   = "255.255.255.0"
    untrust_subnet_gw                = var.untrust_subnet_gateway
    vcn_cidr                         = var.vcn_cidr_block
    trust_subnet_gw                  = var.trust_subnet_gateway
    mgmt_subnet_gw                   = var.mgmt_subnet_gateway
    tenancy_ocid                     = var.tenancy_ocid
    compartment_ocid                 = var.compute_compartment_ocid

  }
}

# ------ Create FortiGate Secondary VM
resource "oci_core_instance" "vm-b" {
  depends_on          = [oci_core_subnet.ha_subnet]
  count = 1
  availability_domain = ( var.availability_domain_name != "" ? var.availability_domain_name : ( length(data.oci_identity_availability_domains.ads.availability_domains) == 1 ? data.oci_identity_availability_domains.ads.availability_domains[0].name : data.oci_identity_availability_domains.ads.availability_domains[count.index].name))
  compartment_id      = var.compute_compartment_ocid
  display_name        = "FortiGate-Secondary-Firewall"
  shape               = var.vm_compute_shape

  create_vnic_details {
    subnet_id        = local.use_existing_network ? var.mangement_subnet_id : oci_core_subnet.mangement_subnet[0].id
    display_name     = "vm-b"
    assign_public_ip = true
    hostname_label   = "vmb"
    private_ip       = var.mgmt_private_ip_primary_b
  }

  source_details {
    source_type = "image"
    source_id   = local.listing_resource_id
  }
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(data.template_file.vm-b_userdata.rendered)
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_vnic_attachment" "vnic_attach_untrust_b" {
  depends_on   = [oci_core_instance.vm-b]
  count = 1
  instance_id  = oci_core_instance.vm-b[count.index].id
  display_name = "vnic_untrust_b"

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.untrust_subnet_id : oci_core_subnet.untrust_subnet[0].id
    display_name           = "vnic_untrust_b"
    assign_public_ip       = false
    skip_source_dest_check = false
    private_ip             = var.untrust_private_ip_primary_b
  }
}


resource "oci_core_vnic_attachment" "vnic_attach_trust_b" {
  depends_on   = [oci_core_vnic_attachment.vnic_attach_untrust_b]
  count = 1
  instance_id  = oci_core_instance.vm-b[count.index].id
  display_name = "vnic_trust"

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.trust_subnet_id : oci_core_subnet.trust_subnet[0].id
    display_name           = "vnic_trust_b"
    assign_public_ip       = false
    skip_source_dest_check = true
    private_ip             = var.trust_private_ip_primary_b
  }
}


resource "oci_core_vnic_attachment" "vnic_attach_hb_b" {
  depends_on   = [oci_core_vnic_attachment.vnic_attach_trust_b]
  count = 1
  instance_id  = oci_core_instance.vm-b[count.index].id
  display_name = "vnic_hb_b"

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.ha_subnet_id : oci_core_subnet.ha_subnet[0].id
    display_name           = "vnic_hb_b"
    assign_public_ip       = false
    skip_source_dest_check = false
    private_ip             = var.hb_private_ip_primary_b
  }
}


data "template_file" "vm-b_userdata" {
  template = file(var.bootstrap_vm-b)

  vars = {
    mgmt_ip                          = var.mgmt_private_ip_primary_b
    mgmt_ip_mask                     = "255.255.255.0"
    untrust_ip                       = var.untrust_private_ip_primary_b
    untrust_ip_mask                  = "255.255.255.0"
    trust_ip                         = var.trust_private_ip_primary_b
    trust_ip_mask                    = "255.255.255.0"
    hb_ip                            = var.hb_private_ip_primary_b
    hb_ip_mask                       = "255.255.255.0"
    hb_peer_ip                       = var.hb_private_ip_primary_a
    untrust_floating_private_ip      = var.untrust_floating_private_ip
    untrust_floating_private_ip_mask = "255.255.255.0"
    trust_floating_private_ip        = var.trust_floating_private_ip
    trust_floating_private_ip_mask   = "255.255.255.0"
    untrust_subnet_gw                = var.untrust_subnet_gateway
    vcn_cidr                         = var.vcn_cidr_block
    trust_subnet_gw                  = var.trust_subnet_gateway
    mgmt_subnet_gw                   = var.mgmt_subnet_gateway

    tenancy_ocid     = var.tenancy_ocid
    compartment_ocid = var.compute_compartment_ocid

  }
}

# ------ Create Web Standalone VMs
resource "oci_core_instance" "web-vms" {
  count = 2

  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domains.ads.availability_domains[count.index + 1].name)
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name_web}-${count.index + 1}"
  shape               = var.spoke_vm_compute_shape
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  dynamic "shape_config" {
    for_each = local.is_spoke_flex_shape
    content {
      ocpus = shape_config.value
    }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.web_transit_subnet_id : oci_core_subnet.web_private-subnet[0].id
    display_name           = var.vm_display_name_web
    assign_public_ip       = false
    nsg_ids                = [oci_core_network_security_group.nsg_web.id]
    skip_source_dest_check = "true"
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[1].id
    boot_volume_size_in_gbs = "50"
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

}

# ------ Create DB Standalone VMs
resource "oci_core_instance" "db-vms" {
  count = 2

  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domains.ads.availability_domains[count.index + 1].name)
  compartment_id      = var.compute_compartment_ocid
  display_name        = "${var.vm_display_name_db}-${count.index + 1}"
  shape               = var.spoke_vm_compute_shape
  fault_domain        = data.oci_identity_fault_domains.fds.fault_domains[count.index].name

  dynamic "shape_config" {
    for_each = local.is_spoke_flex_shape
    content {
      ocpus = shape_config.value
    }
  }

  create_vnic_details {
    subnet_id              = local.use_existing_network ? var.db_transit_subnet_id : oci_core_subnet.db_private-subnet[0].id
    display_name           = var.vm_display_name_db
    assign_public_ip       = false
    nsg_ids                = [oci_core_network_security_group.nsg_db.id]
    skip_source_dest_check = "true"
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[1].id
    boot_volume_size_in_gbs = "50"
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

}
