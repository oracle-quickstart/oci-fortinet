locals {

  availability_domain = (var.availability_domain_name != "" ? var.availability_domain_name : data.oci_identity_availability_domain.ad.name)

  # local.use_existing_network defined in network.tf and referenced here
  use_existing_network = var.network_strategy == var.network_strategy_enum["USE_EXISTING_VCN_SUBNET"] ? true : false

  # Oracle Autonomous Linux 7 platform image for deployment in region
  platform_image_id = data.oci_core_images.autonomous_ol7.images[0].id

  # Logic to choose platform or mkpl image based on
  mp_subscription_enabled  = var.mp_subscription_enabled ? 1 : 0

  compute_image_id = var.mp_subscription_enabled ? local.listing_resource_id : var.custom_image_id

  listing_id = var.marketplace["listing_id"]
  listing_resource_version = var.marketplace_product_version
  listing_resource_id = var.marketplace["versions"][var.marketplace_product_version]["image_ocid"]

  is_flex_shape = var.vm_compute_shape == "VM.Standard.E3.Flex" ? [var.vm_flex_shape_ocpus] : []

  # what-if network related locals used to control 
  is_public_mgmt_subnet = var.mgmt_subnet_type == var.subnet_type_enum["PUBLIC_SUBNET"] ? true : false
  is_public_wan_subnet  = var.wan_subnet_type == var.subnet_type_enum["PUBLIC_SUBNET"] ? true : false
  is_public_lan_subnet  = var.lan_subnet_type == var.subnet_type_enum["PUBLIC_SUBNET"] ? true : false


  is_wan_ingress_all_ports_closed = var.wan_nsg_strategy_ingress == var.nsg_config_enum["BLOCK_ALL_PORTS"] ? true : false
  is_wan_ingress_all_ports_open   = var.wan_nsg_strategy_ingress == var.nsg_config_enum["OPEN_ALL_PORTS"] ? true : false
  is_wan_ingress_customized_ports = var.wan_nsg_strategy_ingress == var.nsg_config_enum["CUSTOMIZE"] ? true : false

  is_wan_egress_all_ports_closed = var.wan_nsg_strategy_egress == var.nsg_config_enum["BLOCK_ALL_PORTS"] ? true : false
  is_wan_egress_all_ports_open   = var.wan_nsg_strategy_egress == var.nsg_config_enum["OPEN_ALL_PORTS"] ? true : false
  is_wan_egress_customized_ports = var.wan_nsg_strategy_egress == var.nsg_config_enum["CUSTOMIZE"] ? true : false

  is_lan_ingress_all_ports_closed = var.lan_nsg_strategy_ingress == var.nsg_config_enum["BLOCK_ALL_PORTS"] ? true : false
  is_lan_ingress_all_ports_open   = var.lan_nsg_strategy_ingress == var.nsg_config_enum["OPEN_ALL_PORTS"] ? true : false
  is_lan_ingress_customized_ports = var.lan_nsg_strategy_ingress == var.nsg_config_enum["CUSTOMIZE"] ? true : false

  is_lan_egress_all_ports_closed = var.lan_nsg_strategy_egress == var.nsg_config_enum["BLOCK_ALL_PORTS"] ? true : false
  is_lan_egress_all_ports_open   = var.lan_nsg_strategy_egress == var.nsg_config_enum["OPEN_ALL_PORTS"] ? true : false
  is_lan_egress_customized_ports = var.lan_nsg_strategy_egress == var.nsg_config_enum["CUSTOMIZE"] ? true : false

}