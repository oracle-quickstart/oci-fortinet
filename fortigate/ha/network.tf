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
  freeform_tags  = map(var.tag_key_name, var.tag_value)
}


#mgmt subnet
resource "oci_core_subnet" "mgmt_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.mgmt_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.simple[count.index].id
  display_name               = var.mgmt_subnet_display_name
  dns_label                  = substr(var.mgmt_subnet_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = ! local.is_public_mgmt_subnet
  security_list_ids          = [oci_core_security_list.mgmt_sec_list.id]

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_route_table_attachment" "mgmt_route_table_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.mgmt_subnet[count.index].id
  route_table_id = oci_core_route_table.mgmt_route_table[count.index].id

}


#untrust subnet
resource "oci_core_subnet" "untrust_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.untrust_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.simple[count.index].id
  display_name               = var.untrust_subnet_display_name
  dns_label                  = substr(var.untrust_subnet_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = ! local.is_public_untrust_subnet
  security_list_ids          = [oci_core_security_list.untrust_sec_list.id]

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_route_table_attachment" "untrust_route_table_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.untrust_subnet[count.index].id
  route_table_id = oci_core_route_table.untrust_route_table[count.index].id
}

#trust subnet
resource "oci_core_subnet" "trust_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.trust_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.simple[count.index].id
  display_name               = var.trust_subnet_display_name
  dns_label                  = substr(var.trust_subnet_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = ! local.is_public_trust_subnet
  security_list_ids          = [oci_core_security_list.trust_sec_list.id]

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_core_route_table_attachment" "trust_route_table_attachment" {
  count          = local.use_existing_network ? 0 : 1
  subnet_id      = oci_core_subnet.trust_subnet[count.index].id
  route_table_id = oci_core_route_table.trust_route_table[count.index].id
}

#ha subnet
resource "oci_core_subnet" "ha_subnet" {
  count                      = local.use_existing_network ? 0 : 1
  cidr_block                 = var.ha_subnet_cidr_block
  compartment_id             = var.network_compartment_ocid
  vcn_id                     = oci_core_vcn.simple[count.index].id
  display_name               = var.ha_subnet_display_name
  dns_label                  = substr(var.ha_subnet_dns_label, 0, 15)
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [oci_core_security_list.ha_sec_list.id]

  freeform_tags = map(var.tag_key_name, var.tag_value)
}



#Network Data Sources

data "oci_core_vcn" "ha_vcn" {
  vcn_id = local.use_existing_network ? join(",", var.vcn_id) : join(",", coalesce(oci_core_vcn.simple.*.id))
}

data "oci_core_subnet" "mgmt_subnet" {
  subnet_id = local.use_existing_network ? join(",", var.mgmt_subnet_id) : join(",", coalesce(oci_core_subnet.mgmt_subnet.*.id))
}

data "oci_core_subnet" "untrust_subnet" {
  subnet_id = local.use_existing_network ? join(",", var.untrust_subnet_id) : join(",", coalesce(oci_core_subnet.untrust_subnet.*.id))
}

data "oci_core_subnet" "trust_subnet" {
  subnet_id = local.use_existing_network ? join(",", var.trust_subnet_id) : join(",", coalesce(oci_core_subnet.trust_subnet.*.id))
}

data "oci_core_subnet" "ha_subnet" {
  subnet_id = local.use_existing_network ? join(",", var.ha_subnet_id) : join(",", coalesce(oci_core_subnet.ha_subnet.*.id))
}