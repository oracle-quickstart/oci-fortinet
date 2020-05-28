variable "use_existing_network" {
  default = false
}

variable "compartment_ocid" {}

variable "vcn_id" {}

variable "igw_display_name" {}

## Untrust Config #

variable "untrust_routetable_display_name" {}

variable "untrust_routetable_destination_cidr_block" {}

variable "untrust_subnet_cidr_block" {}

variable "untrust_security_list_display_name" {}

variable "untrust_security_list_id" {
  default = ""
}

## Trust Config #

variable "trust_routetable_display_name" {}

variable "trust_security_list_display_name" {}

variable "trust_security_list_id" {
  default = ""
}

variable "untrust_routetable_id" {
  default = ""
}

variable "trust_routetable_id" {
  default = ""
}
