locals {

  availability_domain_primary   = (var.availability_domain_name_primary != "" ? var.availability_domain_name_primary : data.oci_identity_availability_domain.ad_primary.name)
  availability_domain_secondary = (var.availability_domain_name_secondary != "" ? var.availability_domain_name_secondary : data.oci_identity_availability_domain.ad_secondary.name)

  # local.use_existing_network defined in network.tf and referenced here
  use_existing_network = var.network_strategy == var.network_strategy_enum["USE_EXISTING_VCN_SUBNET"] ? true : false

  # Oracle Autonomous Linux 7 platform image for deployment in region
  platform_image_id = data.oci_core_images.autonomous_ol7.images[0].id

  # Logic to choose platform or mkpl image based on
  mp_subscription_enabled = var.mp_subscription_enabled ? 1 : 0

  compute_image_id = var.mp_subscription_enabled ? local.listing_resource_id : var.custom_image_id

  listing_id               = var.marketplace["listing_id"]
  listing_resource_version = var.marketplace_product_version
  listing_resource_id      = var.marketplace["versions"][var.marketplace_product_version]["image_ocid"]

  is_flex_shape = var.vm_compute_shape == "VM.Standard.E3.Flex" ? [var.vm_flex_shape_ocpus] : []

  # what-if network related locals used to control 
  is_public_mgmt_subnet    = var.mgmt_subnet_type == var.subnet_type_enum["PUBLIC_SUBNET"] ? true : false
  is_public_untrust_subnet = var.untrust_subnet_type == var.subnet_type_enum["PUBLIC_SUBNET"] ? true : false
  is_public_trust_subnet   = var.trust_subnet_type == var.subnet_type_enum["PUBLIC_SUBNET"] ? true : false


  is_untrust_ingress_all_ports_closed = var.untrust_sec_strategy_ingress == var.nsg_config_enum["BLOCK_ALL_PORTS"] ? true : false
  is_untrust_ingress_all_ports_open   = var.untrust_sec_strategy_ingress == var.nsg_config_enum["OPEN_ALL_PORTS"] ? true : false
  is_untrust_ingress_customized_ports = var.untrust_sec_strategy_ingress == var.nsg_config_enum["CUSTOMIZE"] ? true : false

  is_untrust_egress_all_ports_closed = var.untrust_sec_strategy_egress == var.nsg_config_enum["BLOCK_ALL_PORTS"] ? true : false
  is_untrust_egress_all_ports_open   = var.untrust_sec_strategy_egress == var.nsg_config_enum["OPEN_ALL_PORTS"] ? true : false
  is_untrust_egress_customized_ports = var.untrust_sec_strategy_egress == var.nsg_config_enum["CUSTOMIZE"] ? true : false

  is_trust_ingress_all_ports_closed = var.trust_sec_strategy_ingress == var.nsg_config_enum["BLOCK_ALL_PORTS"] ? true : false
  is_trust_ingress_all_ports_open   = var.trust_sec_strategy_ingress == var.nsg_config_enum["OPEN_ALL_PORTS"] ? true : false
  is_trust_ingress_customized_ports = var.trust_sec_strategy_ingress == var.nsg_config_enum["CUSTOMIZE"] ? true : false

  is_trust_egress_all_ports_closed = var.trust_sec_strategy_egress == var.nsg_config_enum["BLOCK_ALL_PORTS"] ? true : false
  is_trust_egress_all_ports_open   = var.trust_sec_strategy_egress == var.nsg_config_enum["OPEN_ALL_PORTS"] ? true : false
  is_trust_egress_customized_ports = var.trust_sec_strategy_egress == var.nsg_config_enum["CUSTOMIZE"] ? true : false




}