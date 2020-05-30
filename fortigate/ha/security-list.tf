#protocol = Options are supported only for ICMP ("1"), TCP ("6"), UDP ("17"), and ICMPv6 ("58").
#destination_type = CIDR_BLOCK or SERVICE_CIDR_BLOCK
#source_type = CIDR_BLOCK or SERVICE_CIDR_BLOCK

resource "oci_core_security_list" "mgmt_sec_list" {
  #Required
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.simple.0.id

  #Optional
  display_name  = var.mgmt_sec_list_display_name
  freeform_tags = map(var.tag_key_name, var.tag_value)

  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    description      = "Allow all egress traffic"
    destination_type = "CIDR_BLOCK"
    stateless        = false
  }

  #ingress for HTTPS traffic
  ingress_security_rules {
    protocol    = 6
    source      = "0.0.0.0/0"
    description = "Allow Ingress HTTPS traffic"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = var.mgmt_sec_rule_https_port
      min = var.mgmt_sec_rule_https_port
    }
  }
  #ingress for SSH traffic
  ingress_security_rules {
    protocol    = 6
    source      = "0.0.0.0/0"
    description = "Allow Ingress SSH traffic"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      max = var.mgmt_sec_rule_ssh_port
      min = var.mgmt_sec_rule_ssh_port
    }
  }
}

resource "oci_core_security_list" "untrust_sec_list" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.simple.0.id
  display_name   = var.untrust_sec_list_display_name
  freeform_tags  = map(var.tag_key_name, var.tag_value)

  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    description      = "Allow any Egress Traffic (Stateless)"
    destination_type = "CIDR_BLOCK"
    stateless        = true
  }

  ingress_security_rules {
    protocol    = "all"
    source      = "0.0.0.0/0"
    description = "Allow any Ingress Traffic (Stateless)"
    source_type = "CIDR_BLOCK"
    stateless   = true
  }
}

resource "oci_core_security_list" "trust_sec_list" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.simple.0.id
  display_name   = var.trust_sec_list_display_name
  freeform_tags  = map(var.tag_key_name, var.tag_value)

  egress_security_rules {
    destination      = var.vcn_cidr_block
    protocol         = "all"
    description      = "Allow all egress traffic within the VCN"
    destination_type = "CIDR_BLOCK"
    stateless        = true
  }

  ingress_security_rules {
    protocol    = "all"
    source      = var.vcn_cidr_block
    description = "Allow all Ingress traffic within the VCN"
    source_type = "CIDR_BLOCK"
    stateless   = true
  }
}

resource "oci_core_security_list" "ha_sec_list" {
  compartment_id = var.network_compartment_ocid
  vcn_id         = local.use_existing_network ? var.vcn_id : oci_core_vcn.simple.0.id
  display_name   = var.ha_sec_list_display_name
  freeform_tags  = map(var.tag_key_name, var.tag_value)

  egress_security_rules {
    destination      = var.ha_subnet_cidr_block
    protocol         = "all"
    description      = "Allow all egress traffic within the subnet"
    destination_type = "CIDR_BLOCK"
    stateless        = true
  }

  ingress_security_rules {
    protocol    = "all"
    source      = var.ha_subnet_cidr_block
    description = "Allow all ingress traffic within the subnet"
    source_type = "CIDR_BLOCK"
    stateless   = true
  }
}