#This block of code is failing on ORM when destroying resources.
output "instance_public_ip" {
  value = "${module.fortigate-vm.instance-public-ip}"
}

output "instance_public_url" {
  value = "${format("https://%s", module.fortigate-vm.instance-public-ip)}"
}

output "instance_id" {
  value = "${module.fortigate-vm.instance-id}"
}

// output "usage" {
//   value = ["https://${module.fortigate-vm.instance-public-ip} . username = admin and Password = ${module.fortigate-vm.instance-id}"]
// }

