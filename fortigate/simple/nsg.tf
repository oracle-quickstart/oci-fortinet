resource "oci_core_network_security_group" "simple_nsg_mgmt" {
  #Required
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.simple.0.id

  #Optional
  display_name = var.mgmt_nsg_display_name

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_network_security_group" "simple_nsg_wan" {
  #Required
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.simple.0.id

  #Optional
  display_name = var.wan_nsg_display_name

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_network_security_group" "simple_nsg_lan" {
  #Required
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.simple.0.id

  #Optional
  display_name = var.lan_nsg_display_name

  freeform_tags = map(var.tag_key_name, var.tag_value)
}


//MGMT->  allow ingress SSH and HTTPS only and EGRESS all
resource "oci_core_network_security_group_security_rule" "mgmt_rule_egress" {
  network_security_group_id = oci_core_network_security_group.simple_nsg_mgmt.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"

}

resource "oci_core_network_security_group_security_rule" "mgmt_rule_ssh_ingress" {
  network_security_group_id = oci_core_network_security_group.simple_nsg_mgmt.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.mgmt_nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.mgmt_nsg_ssh_port
      max = var.mgmt_nsg_ssh_port
    }
  }
}

resource "oci_core_network_security_group_security_rule" "mgmt_rule_https_ingress" {
  network_security_group_id = oci_core_network_security_group.simple_nsg_mgmt.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.mgmt_nsg_source_cidr
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = var.mgmt_nsg_https_port
      max = var.mgmt_nsg_https_port
    }
  }
}


//WAN and LAN -> block all ingress, allow all egress
// locals.is_wan_ingress_all_ports_closed
// locals.is_wan_ingress_all_ports_open
// locals.is_wan_ingress_customized_ports

resource "oci_core_network_security_group_security_rule" "wan_ingress_all_ports_open" {
  count                     = local.is_wan_ingress_all_ports_open ? 1 : 0
  network_security_group_id = oci_core_network_security_group.simple_nsg_wan.id
  protocol                  = "all"
  direction                 = "INGRESS"
  source                    = var.wan_nsg_source_cidr
  stateless                 = false
}

resource "oci_core_network_security_group_security_rule" "wan_egress_all_ports_open" {
  count                     = local.is_wan_egress_all_ports_open ? 1 : 0
  network_security_group_id = oci_core_network_security_group.simple_nsg_wan.id
  protocol                  = "all"
  direction                 = "EGRESS"
  destination               = "0.0.0.0/0"
  stateless                 = false
}

resource "oci_core_network_security_group_security_rule" "lan_ingress_all_ports_open" {
  count                     = local.is_lan_ingress_all_ports_open ? 1 : 0
  network_security_group_id = oci_core_network_security_group.simple_nsg_lan.id
  protocol                  = "all"
  direction                 = "INGRESS"
  source                    = var.lan_nsg_source_cidr
  stateless                 = false
}

resource "oci_core_network_security_group_security_rule" "lan_egress_all_ports_open" {
  count                     = local.is_lan_egress_all_ports_open ? 1 : 0
  network_security_group_id = oci_core_network_security_group.simple_nsg_lan.id
  protocol                  = "all"
  direction                 = "EGRESS"
  destination               = "0.0.0.0/0"
  stateless                 = false
}

#WAN accept INGRESS traffic from LAN
resource "oci_core_network_security_group_security_rule" "wan_to_lan_ingress" {
  count                     = local.is_wan_ingress_all_ports_open ? 1 : 0
  network_security_group_id = oci_core_network_security_group.simple_nsg_wan.id
  protocol                  = "all"
  direction                 = "INGRESS"
  source                    = var.lan_nsg_source_cidr
  stateless                 = false
}

#WAN sent EGRESS traffic to LAN
resource "oci_core_network_security_group_security_rule" "wan_to_lan_egress" {
  count                     = local.is_wan_ingress_all_ports_open ? 1 : 0
  network_security_group_id = oci_core_network_security_group.simple_nsg_wan.id
  protocol                  = "all"
  direction                 = "EGRESS"
  destination               = var.lan_nsg_source_cidr
  stateless                 = false
}

#LAN accept INGRESS traffic from WAN
resource "oci_core_network_security_group_security_rule" "lan_to_wan_ingress" {
  count                     = local.is_wan_ingress_all_ports_open ? 1 : 0
  network_security_group_id = oci_core_network_security_group.simple_nsg_lan.id
  protocol                  = "all"
  direction                 = "INGRESS"
  source                    = var.wan_nsg_source_cidr
  stateless                 = false
}

#LAN sent EGRESS traffic to WAN
resource "oci_core_network_security_group_security_rule" "lan_to_wan_egress" {
  count                     = local.is_wan_ingress_all_ports_open ? 1 : 0
  network_security_group_id = oci_core_network_security_group.simple_nsg_lan.id
  protocol                  = "all"
  direction                 = "EGRESS"
  destination               = var.wan_nsg_source_cidr
  stateless                 = false
}
