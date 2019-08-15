// variable "tenancy_ocid" {
//   default = ""
// }

// variable "region" {
//   default = ""
// }

# Choose an Availability Domain (1,2,3)
variable "availability_domain" {
  default = ""
}

variable "compartment_ocid" {
  default = ""
}

variable "vcn_cidr_block" {
  default = "10.2.0.0/16"
}

variable "vcn_display_name" {
  default = "fortigate-vcn"
}

variable "vcn_dns_label" {
  default = "fortigatevcn"
}

variable "igw_display_name" {
  default = "internet gateway"
}

variable "untrust_routetable_display_name" {
  default = "public-rt"
}

variable "untrust_routetable_destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "untrust_subnet_cidr_block" {
  default = "10.2.1.0/24"
}

variable "untrust_subnet_display_name" {
  default = "public-subnet"
}

variable "untrust_subnet_dns_label" {
  default = "public"
}

variable "trust_routetable_display_name" {
  default = "protected-rt"
}

variable "trust_subnet_cidr_block" {
  default = "10.2.2.0/24"
}

variable "trust_subnet_display_name" {
  default = "protected-subnet"
}

variable "trust_subnet_dns_label" {
  default = "protected"
}

variable "untrust_security_list_display_name" {
  default = "public-security-list"
}

variable "trust_security_list_display_name" {
  default = "protected-security-list"
}

#VM Variables
variable "vm_display_name" {
  default = "fortigate-vm"
}

variable "compute_shape" {
  default = "VM.Standard2.1"
}

variable "fortigate_license_key" {
  default = ""
}

variable "untrust_vnic_display_name" {
  default = "public"
}

variable "untrust_vnic_hostname_label" {
  default = "fortigate"
}

variable "assign_public_ip" {
  default = true
}

variable "trust_vnic_display_name" {
  default = "protected"
}

variable "trust_vnic_hostname_label" {
  default = "fortigate"
}

variable "block_volume_display_name" {
  default = "fortigate"
}

variable "block_volume_size" {
  default = "50" //GB
}

variable "customize_config" {
  default = "false"
}
