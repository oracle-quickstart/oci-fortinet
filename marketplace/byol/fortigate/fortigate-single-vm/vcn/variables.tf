variable "compartment_ocid" {}

variable "use_existing_network" {
  default = false
}

variable "vcn_cidr_block" {
  default = ""
}

variable "vcn_display_name" {
  default = "fortigate-vcn"
}

variable "vcn_dns_label" {
  default = "fortigatevcn"
}

variable "vcn_id" {
  default = ""
}

variable "default_dhcp_options_id" {
  default = ""
}

variable "default_security_list_id" {
  default = ""
}

