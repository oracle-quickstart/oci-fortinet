variable "use_existing_network" {}

variable "availability_domain" {
  default = ""
}

variable "vcn_id" {}
variable "cidr_block" {}
variable "display_name" {}
variable "compartment_ocid" {}
variable "route_table_id" {}

variable "security_list_ids" {
  type = "list"
}

variable "dhcp_options_id" {}
variable "dns_label" {}
variable "allow_public_ip" {}

variable "subnet_id" {
  default = ""
}
