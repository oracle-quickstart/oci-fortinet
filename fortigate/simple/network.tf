resource "oci_core_vcn" "simple" {
  count          = local.use_existing_network ? 0 : 1
  cidr_block     = var.vcn_cidr_block
  dns_label      = substr(var.vcn_dns_label, 0, 15)
  compartment_id = var.network_compartment_ocid
  display_name   = var.vcn_display_name

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

#IGW
resource "oci_core_internet_gateway" "simple_internet_gateway" {
  count          = local.use_existing_network ? 0 : 1
  compartment_id = var.network_compartment_ocid
  vcn_id         = oci_core_vcn.simple[count.index].id
  enabled        = "true"
  display_name   = "${var.vcn_display_name}-igw"

  freeform_tags = map(var.tag_key_name, var.tag_value)
}


#mgmt subnet
resource "oci_core_subnet" "simple_mgmt_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.mgmt_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.simple[count.index].id
  display_name               = var.mgmt_subnet_display_name
  dns_label                  = substr(var.mgmt_subnet_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = ! local.is_public_mgmt_subnet

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_route_table_attachment" "simple_mgmt_route_table_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.simple_mgmt_subnet[count.index].id
  route_table_id = oci_core_route_table.simple_mgmt_wan_route_table[count.index].id

}


#wan subnet
resource "oci_core_subnet" "simple_wan_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.wan_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.simple[count.index].id
  display_name               = var.wan_subnet_display_name
  dns_label                  = substr(var.wan_subnet_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = ! local.is_public_wan_subnet

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_route_table_attachment" "simple_wan_route_table_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.simple_wan_subnet[count.index].id
  route_table_id = oci_core_route_table.simple_mgmt_wan_route_table[count.index].id
}

#lan subnet
resource "oci_core_subnet" "simple_lan_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.lan_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.simple[count.index].id
  display_name               = var.lan_subnet_display_name
  dns_label                  = substr(var.lan_subnet_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = ! local.is_public_lan_subnet

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_route_table_attachment" "simple_lan_route_table_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.simple_lan_subnet[count.index].id
  route_table_id = oci_core_route_table.simple_lan_route_table[count.index].id
}
