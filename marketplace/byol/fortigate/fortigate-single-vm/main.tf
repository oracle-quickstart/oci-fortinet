module "fortigate-vcn" {
  source = "./vcn"

  use_existing_network = "false"
  vcn_cidr_block       = "${var.vcn_cidr_block}"
  compartment_ocid       = "${var.compartment_ocid}"
  vcn_display_name     = "${var.vcn_display_name}"
  vcn_dns_label        = "${var.vcn_dns_label}"
  
  //optionally point to existing resources
  // vcn_id = "${var.vcn_id}"
  // default_dhcp_options_id = "${var.default_dhcp_options_id}"
  // default_security_list_id = "${var.default_security_list_id}"
}

module "fortigate-network-config" {
  source = "./vcn_subnet_config"

  use_existing_network                      = "false"
  compartment_ocid                            = "${var.compartment_ocid}"
  vcn_id                                    = "${module.fortigate-vcn.vcn_id}"
  igw_display_name                          = "${var.igw_display_name}"
  untrust_routetable_display_name           = "${var.untrust_routetable_display_name}"
  untrust_routetable_destination_cidr_block = "${var.untrust_routetable_destination_cidr_block}"
  trust_routetable_display_name             = "${var.trust_routetable_display_name}"
  untrust_security_list_display_name        = "${var.untrust_security_list_display_name}"
  trust_security_list_display_name          = "${var.trust_security_list_display_name}"
  untrust_subnet_cidr_block                 = "${var.untrust_subnet_cidr_block}"

// //optionally point to existing resources
//   untrust_routetable_id = "${var.untrust_routetable_id}"
//   trust_routetable_id = "${var.trust_routetable_id}"
//   untrust_security_list_id = "${var.untrust_security_list_id}"
//   trust_security_list_id = "${var.trust_security_list_id}"


}

module "fortigate-untrust-subnet" {
  source = "./subnet"

  use_existing_network = "false"

  //ad is optional for regional subnets
  //   availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  
  //regional subnet
  availability_domain = ""
  vcn_id          = "${module.fortigate-vcn.vcn_id}"
  cidr_block      = "${var.untrust_subnet_cidr_block}"
  display_name    = "${var.untrust_subnet_display_name}"
  compartment_ocid  = "${var.compartment_ocid}"
  route_table_id  = "${module.fortigate-network-config.untrust_routetable_id}"
  dhcp_options_id = "${module.fortigate-vcn.default_dhcp_options_id}"

  security_list_ids = ["${module.fortigate-vcn.default_security_list_id}",
    "${module.fortigate-network-config.untrust_security_list_id}",
  ]

  dns_label       = "${var.untrust_subnet_dns_label}"
  allow_public_ip = "${var.assign_public_ip}"
  // subnet_id = "${var.untrust_subnet_id}"
}

module "fortigate-trust-subnet" {
  source = "./subnet"

  use_existing_network = "false"
  //regional subnet
  availability_domain = ""
  vcn_id               = "${module.fortigate-vcn.vcn_id}"
  cidr_block           = "${var.trust_subnet_cidr_block}"
  display_name         = "${var.trust_subnet_display_name}"
  compartment_ocid       = "${var.compartment_ocid}"
  route_table_id       = "${module.fortigate-network-config.trust_routetable_id}"
  dhcp_options_id      = "${module.fortigate-vcn.default_dhcp_options_id}"

  security_list_ids = ["${module.fortigate-vcn.default_security_list_id}",
    "${module.fortigate-network-config.trust_security_list_id}",
  ]

  dns_label = "${var.trust_subnet_dns_label}"
  // subnet_id = "${var.trust_subnet_id}"
  allow_public_ip = "false"
}

module "fortigate-vm" {
  source = "./compute"

  mp_listing_id = "${var.mp_listing_id}"
  mp_listing_resource_id = "${var.mp_listing_resource_id}"
  mp_listing_resource_version = "${var.mp_listing_resource_version}"

  tenancy_ocid        = "${var.tenancy_ocid}"
  compartment_ocid      = "${var.compartment_ocid}"
  availability_domain = "${var.availability_domain}"

  vm_display_name       = "${var.vm_display_name}"
  compute_shape         = "${var.compute_shape}"
  fortigate_license_key = "${var.fortigate_license_key}"

  untrust_subnet_id           = "${module.fortigate-untrust-subnet.subnet_id}"
  untrust_vnic_display_name   = "${var.untrust_vnic_display_name}"
  untrust_vnic_hostname_label = "${var.untrust_vnic_hostname_label}"
  assign_public_ip            = "${var.assign_public_ip}"

  trust_subnet_id           = "${module.fortigate-trust-subnet.subnet_id}"
  trust_vnic_display_name   = "${var.trust_vnic_display_name}"
  trust_vnic_hostname_label = "${var.trust_vnic_hostname_label}"

  block_volume_display_name = "${var.block_volume_display_name}"
  block_volume_size         = "${var.block_volume_size}"
}
