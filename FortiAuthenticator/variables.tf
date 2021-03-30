variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}

variable "private_key_path" {}

variable "region" {
  default = "us-ashburn-1"
}

variable "compartment_ocid" {}

variable "vcn_cidr" {
  default = "10.3.0.0/16"
}

variable "untrust_subnet_cidr" {
  default = "10.3.1.0/24"
}


variable "vm_image_ocid" {
  // FortiAuthenticator Marketplace Image 6.2.1
  default = "ocid1.image.oc1..aaaaaaaanrcqiqx3hqzce6xw7ti4wxzf2j3ux7g35qwy5xk4lhtml4mjxgvq"
}

variable "instance_shape" {
  default = "VM.Standard2.1"
}

# Choose an Availability Domain (1,2,3)
variable "availability_domain" {
  default = "1"
}

variable "volume_size" {
  default = "50" //GB
}
