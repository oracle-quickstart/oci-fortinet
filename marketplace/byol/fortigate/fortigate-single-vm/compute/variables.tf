variable "use_marketplace_image" {
  default = true
}

variable "custom_image_id" {
  default = ""
}

variable "compartment_ocid" {}
variable "availability_domain" {}
variable "vm_display_name" {}
variable "compute_shape" {}
variable "fortigate_license_key" {}

variable "untrust_subnet_id" {}
variable "untrust_vnic_display_name" {}
variable "untrust_vnic_hostname_label" {}

variable "assign_public_ip" {}

variable "trust_subnet_id" {}
variable "trust_vnic_display_name" {}
variable "trust_vnic_hostname_label" {}

variable "block_volume_display_name" {}
variable "block_volume_size" {}

variable "mp_listing_id" {}
variable "mp_listing_resource_id" {}
variable "mp_listing_resource_version" {}
