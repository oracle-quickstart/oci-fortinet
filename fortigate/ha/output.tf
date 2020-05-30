output "primary_instance_name" {
  value = oci_core_instance.primary_instance.display_name
}

output "primary_instance_ocid" {
  value = oci_core_instance.primary_instance.id
}

output "primary_instance_mgmt_public_ip" {
  value = oci_core_instance.primary_instance.public_ip
}

output "primary_instance_mgmt_private_ip" {
  value = oci_core_instance.primary_instance.private_ip
}

output "primary_instance_mgmt_https_url" {
  value = "https://${oci_core_instance.primary_instance.public_ip}"
}

output "primary_instance_untrust_mac_address" {
  value = data.oci_core_vnic.untrust_vnic_primary_instance.mac_address
}

output "primary_instance_trust_mac_address" {
  value = data.oci_core_vnic.trust_vnic_primary_instance.mac_address
}

output "primary_instance_ha_private_ip" {
  value = data.oci_core_vnic.ha_vnic_primary_instance.private_ip_address
}


output "primary_instance_ha_mac_address" {
  value = data.oci_core_vnic.ha_vnic_primary_instance.mac_address
}

output "secondary_instance_name" {
  value = oci_core_instance.secondary_instance.display_name
}

output "secondary_instance_ocid" {
  value = oci_core_instance.secondary_instance.id
}

output "secondary_instance_mgmt_public_ip" {
  value = oci_core_instance.secondary_instance.public_ip
}

output "secondary_instance_mgmt_private_ip" {
  value = oci_core_instance.secondary_instance.private_ip
}

output "secondary_instance_mgmt_https_url" {
  value = "https://${oci_core_instance.secondary_instance.public_ip}"
}

output "secondary_instance_untrust_mac_address" {
  value = data.oci_core_vnic.untrust_vnic_secondary_instance.mac_address
}

output "secondary_instance_trust_mac_address" {
  value = data.oci_core_vnic.trust_vnic_secondary_instance.mac_address
}

output "secondary_instance_ha_mac_address" {
  value = data.oci_core_vnic.ha_vnic_secondary_instance.mac_address
}


output "untrust_public_ip" {
  value = (local.is_public_untrust_subnet ? oci_core_public_ip.untrust_reserved_public_ip[0].ip_address : "N/A")
}

output "trust_public_ip" {
  value = (local.is_public_trust_subnet ? oci_core_public_ip.trust_reserved_public_ip[0].ip_address : "N/A")
}


output "untrust_floating_ip" {
  value = oci_core_private_ip.untrust_floating_ip.ip_address
}

output "trust_floating_ip" {
  value = oci_core_private_ip.trust_floating_ip.ip_address
}


output "marketplace_subscription_to" {
  value = "listing_id=${local.listing_id}, package_resource_version=${local.listing_resource_version}, pic_image_ocid=${local.listing_resource_id}"
}