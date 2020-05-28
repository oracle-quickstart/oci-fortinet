#################################################################################
##########                    Route Tables                           ############
#################################################################################

#Management and WAN route table
resource "oci_core_route_table" "simple_mgmt_wan_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.simple[count.index].id
  display_name   = "${var.mgmt_subnet_display_name}-${var.wan_subnet_display_name}-rt"
  route_rules {
    network_entity_id = oci_core_internet_gateway.simple_internet_gateway[count.index].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

#LAN route table
resource "oci_core_route_table" "simple_lan_route_table" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.simple[count.index].id
  display_name   = "${var.lan_subnet_display_name}-rt"
  route_rules {
    network_entity_id = data.oci_core_private_ips.simple_lan_vnic_private_ips.private_ips[0].id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  freeform_tags = map(var.tag_key_name, var.tag_value)
}