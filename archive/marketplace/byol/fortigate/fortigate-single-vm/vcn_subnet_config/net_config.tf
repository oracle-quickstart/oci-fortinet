resource "oci_core_internet_gateway" "igw" {
  count          = "${var.use_existing_network ? 0:1}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.igw_display_name}"
  vcn_id         = "${var.vcn_id}"
}

####################################
## UNTRUST NETWORK SETTINGS   ##
###################################

resource "oci_core_route_table" "untrust_routetable" {
  count          = "${var.use_existing_network ? 0:1}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${var.vcn_id}"
  display_name   = "${var.untrust_routetable_display_name}"

  route_rules {
    destination       = "${var.untrust_routetable_destination_cidr_block}"
    network_entity_id = "${oci_core_internet_gateway.igw.id}"
  }
}

# Protocols are specified as protocol numbers.
# http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
resource "oci_core_security_list" "untrust_security_list" {
  count          = "${var.use_existing_network ? 0:1}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${var.vcn_id}"
  display_name   = "${var.untrust_security_list_display_name}"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow inbound http (port 80) traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 80
      "max" = 80
    }
  }

  // allow inbound http (port 443) traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 443
      "max" = 443
    }
  }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = "6"         // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      "min" = 22
      "max" = 22
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      "type" = 3
      "code" = 4
    }
  }
}

###############################
## TRUST NETWORK SETTINGS    ##
###############################

resource "oci_core_route_table" "trust_routetable" {
  count          = "${var.use_existing_network ? 0:1}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${var.vcn_id}"
  display_name   = "${var.trust_routetable_display_name}"
}

# Protocols are specified as protocol numbers.
# http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml
resource "oci_core_security_list" "trust_security_list" {
  count          = "${var.use_existing_network ? 0:1}"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${var.vcn_id}"
  display_name   = "${var.trust_security_list_display_name}"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow outbound udp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17"        // udp
    stateless   = true
  }

  // allow inbound traffic on all ports from network
  ingress_security_rules {
    protocol  = "6"                                // tcp
    source    = "${var.untrust_subnet_cidr_block}"
    stateless = false
  }
}
