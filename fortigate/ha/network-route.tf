#################################################################################
##########                    Route Tables                           ############
#################################################################################

#Management
resource "oci_core_route_table" "mgmt_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.simple[count.index].id
  display_name   = "${var.mgmt_subnet_display_name}-rt"
  route_rules {
    network_entity_id = oci_core_internet_gateway.simple_internet_gateway[count.index].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

#Untrust route table
resource "oci_core_route_table" "untrust_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.simple[count.index].id
  display_name   = "${var.untrust_subnet_display_name}-rt"
  route_rules {
    network_entity_id = oci_core_internet_gateway.simple_internet_gateway[count.index].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  freeform_tags = map(var.tag_key_name, var.tag_value)
}

#Trust route table
resource "oci_core_route_table" "trust_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.simple[count.index].id
  display_name   = "${var.trust_subnet_display_name}-rt"
  route_rules {
    network_entity_id = oci_core_private_ip.trust_floating_ip.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  freeform_tags = map(var.tag_key_name, var.tag_value)
}