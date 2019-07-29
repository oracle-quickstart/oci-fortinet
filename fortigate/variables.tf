variable "tenancy_ocid" {}
// variable "user_ocid" {}
// variable "fingerprint" {}

// variable "private_key_path" {}

variable "region" {
  default = "us-ashburn-1"
}

variable "compartment_ocid" {}

variable "vcn_cidr" {
  default = "10.2.0.0/16"
}

variable "untrust_subnet_cidr" {
  default = "10.2.1.0/24"
}



variable "trust_subnet_cidr" {
  default = "10.2.2.0/24"
}

variable "trust_private_ip_primary" {
  default = "10.2.2.2"
}

variable "trust_floating_private_ip" {
  default = "10.2.2.10"
}

// variable "vm_image_ocid" {
//   default = "PIC or custom image OCID"
// }

variable "vm_image_ocid" {
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.4-2018.02.21-1"
	// Example:
    //us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaqxxs4ve4kweolwtw3afbhkqvvloyh77tmeb2a6i3mdmcykdqaidq"

    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaajjozwgudxjj4ao43ma5j3a7ytauypmyod2ebv6nfahwwurknrsqa"
    //eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7d3fsb6272srnftyi4dphdgfjf6gurxqhmv6ileds7ba3m2gltxq"
    //uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaa6h6gj6v4n56mqrbgnosskq63blyv2752g36zerymy63cfkojiiq"
  }
}

variable "instance_shape" {
  default = "VM.Standard2.4"
}

# Choose an Availability Domain (1,2,3)
variable "availability_domain" {
  default = "1"
}

variable "volume_size" {
  default = "50" //GB
}
