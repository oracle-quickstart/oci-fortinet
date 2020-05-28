output "instance-public-ip" {
  value = "${data.oci_core_instance.vm.public_ip}"
}

output "instance-id" {
  value = "${oci_core_instance.vm.id}"
}
