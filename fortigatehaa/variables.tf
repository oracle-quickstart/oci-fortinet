variable "tenancy_ocid" {}
variable "oci_user_ocid" {}
// variable "user_ocid" {}
// variable "fingerprint" {}

// variable "private_key_path" {}
variable "region" {
  default = "us-ashburn-1"
}

variable "compartment_ocid" {}

##VCN and SUBNET ADDRESSESS
variable "vcn_cidr" {
  default = "10.1.0.0/16"
}

variable "mgmt_subnet_cidr" {
  default = "10.1.1.0/24"
}

variable "mgmt_subnet_gateway" {
  default = "10.1.1.1"
}


variable "untrust_subnet_cidr" {
  default = "10.1.10.0/24"
}

variable "untrust_subnet_gateway" {
  default = "10.1.10.1"
}

variable "untrust_public_ip_lifetime" {
  default = "RESERVED"
  //or EPHEMERAL
}


variable "trust_subnet_cidr" {
  default = "10.1.100.0/24"
}

variable "trust_subnet_gateway" {
  default = "10.1.100.1"
}

variable "hb_subnet_cidr" {
  default = "10.1.200.0/24"
}


#FIREWALL IPs

#FLOATING/FAILOVER
variable "untrust_floating_private_ip" {
  default = "10.1.10.10"
}

variable "trust_floating_private_ip" {
  default = "10.1.100.10"
}


#ACTIVE NODE
variable "mgmt_private_ip_primary_a" {
  default = "10.1.1.2"
}

variable "untrust_private_ip_primary_a" {
  default = "10.1.10.2"
}

variable "trust_private_ip_primary_a" {
  default = "10.1.100.2"
}

variable "hb_private_ip_primary_a" {
  default = "10.1.200.2"
}

#PASSIVE NODE
variable "mgmt_private_ip_primary_b" {
  default = "10.1.1.20"
}

variable "untrust_private_ip_primary_b" {
  default = "10.1.10.20"
}

variable "trust_private_ip_primary_b" {
  default = "10.1.100.20"
}

variable "hb_private_ip_primary_b" {
  default = "10.1.200.20"
}




// variable "vm_image_ocid" {
//   default = "PIC or custom image OCID"
// }

variable "vm_image_ocid" {
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // FortiGate-6.0.3-emulated"
	// Example:
  //us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaupbfz5f5hdvejulmalhyb6goieolullgkpumorbvxlwkaowglslq"
  us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaajjozwgudxjj4ao43ma5j3a7ytauypmyod2ebv6nfahwwurknrsqa"
  //PV Mode
  //us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaa64vovumtrx5gqk6uei4dkopjjbtq3dwl5nirx5ah5kbq7tubclha"

  //  eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7d3fsb6272srnftyi4dphdgfjf6gurxqhmv6ileds7ba3m2gltxq"
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

variable "bootstrap_vm-a" {
  default = "./userdata/bootstrap_vm-a.tpl"
}

//variable "license_vm-a" {
//  default = "./license/FGVM080000175530.lic"
//}


variable "bootstrap_vm-b" {
 default = "./userdata/bootstrap_vm-b.tpl"
}

//variable "license_vm-b" {
//  default = "./license/FGVM080000175531.lic"
//}

variable "sdn_oci_certificate_name" {
  default = "Fortinet_Factory"
}

variable "sdn_region" {
  default = "ashburn"
}