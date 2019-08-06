// output "instance-public-ip" {
//   depends_on = ["data.oci_core_vnic.InstanceVnic"]
//   value = ["${data.oci_core_vnic.InstanceVnic.public_ip_address}"]
// }

output "instance-id" {
  value = ["${oci_core_instance.vm.id}"]
}
