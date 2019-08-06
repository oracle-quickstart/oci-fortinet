// #This block of code is failing on ORM when destroying resources.
// output "instance-public-ip" {
//   depends_on = ["data.oci_core_vnic.InstanceVnic"]
//   value = ["${data.oci_core_vnic.InstanceVnic.public_ip_address}"]
// }
// output "instance-id" {
//   value = ["${oci_core_instance.vm.id}"]
// }
// output "Usage" {
//   depends_on = ["data.oci_core_vnic.InstanceVnic"]
//   value      = ["Open up your browser and go to https://${data.oci_core_vnic.InstanceVnic.public_ip_address} . username = admin and Password = ${oci_core_instance.vm.id}"]
// }

