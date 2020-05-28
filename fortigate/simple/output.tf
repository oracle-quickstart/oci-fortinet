output "simple_instance_ocid" {
  value = oci_core_instance.simple.id
}

output "instance_mgmt_public_ip" {
  value = oci_core_instance.simple.public_ip
}

output "instance_mgmt_private_ip" {
  value = oci_core_instance.simple.private_ip
}

output "instance_mgmt_https_url" {
  value = "https://${oci_core_instance.simple.public_ip}"
}

output "instance_wan_public_ip" {
  value = (local.is_public_wan_subnet ? oci_core_public_ip.wan_reserved_public_ip[0].ip_address : "N/A")
}

output "instance_wan_private_ip" {
  value = data.oci_core_private_ips.simple_wan_vnic_private_ips.private_ips[0].ip_address
}

output "instance_lan_public_ip" {
  value = (local.is_public_lan_subnet ? oci_core_public_ip.lan_reserved_public_ip[0].ip_address : "N/A")
}

output "instance_lan_private_ip" {
  value = data.oci_core_private_ips.simple_lan_vnic_private_ips.private_ips[0].ip_address
}


output "marketplace_subscription_to" {
  value = "listing_id=${local.listing_id}, package_resource_version=${local.listing_resource_version}, pic_image_ocid=${local.listing_resource_id}"
}