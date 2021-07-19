output "firewallA_instance_public_ips" {
  value = [oci_core_instance.firewall-vms[0].*.public_ip]
}

output "firewallA_instance_private_ips" {
  value = [oci_core_instance.firewall-vms[0].*.private_ip]
}

output "firewallB_instance_public_ips" {
  value = [oci_core_instance.firewall-vms[1].*.public_ip]
}

output "firewallB_instance_private_ips" {
  value = [oci_core_instance.firewall-vms[1].*.private_ip]
}

output "instance_https_urls" {
  value = formatlist("https://%s", oci_core_instance.firewall-vms.*.public_ip)
}

output "initial_instruction" {
value = <<EOT
1. In a web browser, 
    - Connect to the VM Series UI Firewall-1: https://${oci_core_instance.firewall-vms.0.public_ip}
    - Connect to the VM Series UI Firewall-2: https://${oci_core_instance.firewall-vms.1.public_ip}
2. Upload a Valid License, procure one from Partner or Use Paid Listings
3. Follow official Deployment Guide to configure FortiGate Firewalls.
EOT
}