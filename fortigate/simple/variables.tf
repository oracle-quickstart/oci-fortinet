#Variables declared in this file must be declared in the marketplace.yaml

############################
#  Hidden Variable Group   #
############################
variable "tenancy_ocid" {
}

variable "region" {
}

############################
#  Marketplace Image      #
############################
variable "mp_subscription_enabled" {
  description = "Subscribe to Marketplace listing?"
  type        = bool
  default     = true
}

variable "marketplace_product_version" {
  default = "6.2.3_SR-IOV_Paravirtualized_Mode"
  // default = "6.4.0_SR-IOV_Paravirtualized_Mod"
}


variable "marketplace" {
  description = "Marketplace listing definition"
  type = object ({
    listing_id = string
    versions = map(object({
      image_ocid      = string
    }))
  })

  default = {
    listing_id = "ocid1.appcataloglisting.oc1..aaaaaaaam7ewzrjbltqiarxukuk72v2lqkdtpqtwxqpszqqvrm7likfnpt5q"
    versions = {
      "6.4.0_SR-IOV_Paravirtualized_Mod" = {
        image_ocid = "ocid1.image.oc1..aaaaaaaaa5u7qtj3j3um4zryg3qkn6if2sqctqjfh46pdq5z56kq6zagg4va"
      }, 
      "6.2.3_SR-IOV_Paravirtualized_Mode" = {
        image_ocid = "ocid1.image.oc1..aaaaaaaaxyhftjifo6rjz4i76tv2odlcczxhlmfkacd5cap6f6luuhbksiua"
      }
    }
  }
}

// variable "mp_listing_id" {
//   // default = "ocid1.appcataloglisting.oc1.."
//   default     = "ocid1.appcataloglisting.oc1..aaaaaaaam7ewzrjbltqiarxukuk72v2lqkdtpqtwxqpszqqvrm7likfnpt5q"
//   description = "Marketplace Listing OCID"
// }

// variable "mp_listing_resource_id" {
//   // default = "ocid1.image.oc1.."

//   //6.4
//   default     = "ocid1.image.oc1..aaaaaaaaa5u7qtj3j3um4zryg3qkn6if2sqctqjfh46pdq5z56kq6zagg4va"
//   description = "Marketplace Listing Image OCID"
// }

// variable "mp_listing_resource_version" {
//   // default = "1.0"
//   //Package Version Reference:	6.2.3_SR-IOV_Paravirtualized_Mode
//   default     = "6.4.0_SR-IOV_Paravirtualized_Mod"
//   description = "Marketplace Listing Package/Resource Version"
// }

############################
#  Custom Image           #
############################


variable "custom_image_id" {
  default     = ""
  description = "Custom Image OCID"
}

// ############################
// #  Platform Image           #
// ############################

// # OS Images
// variable "instance_os" {
//   description = "Operating system for compute instances"
//   default     = "Oracle Linux"
// }

// variable "linux_os_version" {
//   description = "Operating system version for all Linux instances"
//   default     = "7.7"
// }

############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "fortigate-simple"
}

variable "vm_license_key" {
  description = "FortiGate License Key"
  default     = ""
}


variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //4 cores / 4 vnics
}

# only used for E3 Flex shape
variable "vm_flex_shape_ocpus" {
  description = "Flex Shape OCPUs"
  default     = 1
}

variable "availability_domain_name" {
  default     = ""
  description = "Availability Domain"
}

variable "availability_domain_number" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
}

variable "ssh_public_key" {
  description = "SSH Public Key"
}

variable "hostname_label" {
  default     = "fortigate"
  description = "DNS Hostname Label. Must be unique across all VNICs in the subnet and comply with RFC 952 and RFC 1123."
}

variable "vm_block_volume_size" {
  description = "Block Volume size attached to the VM"
  default     = 50
}


############################
#  Network Configuration   #
############################

variable "network_strategy" {
  default = "Create New VCN and Subnet"
}

variable "vcn_id" {
  default = ""
}

variable "vcn_display_name" {
  description = "VCN Name"
  default     = "fortigate-simple"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "simplevcn"
}

variable "mgmt_subnet_type" {
  description = "Choose between private and public subnets"
  default     = "Public Subnet"
}

variable "wan_subnet_type" {
  description = "Choose between private and public subnets"
  default     = "Public Subnet"
}

variable "lan_subnet_type" {
  description = "Choose between private and public subnets"
  default     = "Private Subnet"
}

variable "mgmt_subnet_id" {
  default = ""
}

variable "wan_subnet_id" {
  default = ""
}

variable "lan_subnet_id" {
  default = ""
}

variable "mgmt_subnet_display_name" {
  description = "Management Subnet Name"
  default     = "simple-mgmt"
}

variable "mgmt_subnet_cidr_block" {
  description = "MGMT Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "mgmt_subnet_dns_label" {
  description = "Subnet DNS Label"
  default     = "management"
}

variable "lan_subnet_display_name" {
  description = "LAN Subnet Name"
  default     = "simple-lan"
}

variable "lan_subnet_cidr_block" {
  description = "LAN Subnet CIDR"
  default     = "10.0.10.0/24"
}

variable "lan_subnet_dns_label" {
  description = "LAN Subnet DNS Label"
  default     = "lan"
}


variable "wan_subnet_display_name" {
  description = "WAN Subnet Name"
  default     = "simple-wan"
}

variable "wan_subnet_cidr_block" {
  description = "WAN Subnet CIDR"
  default     = "10.0.100.0/24"
}

variable "wan_subnet_dns_label" {
  description = "WAN Subnet DNS Label"
  default     = "wan"
}

############################
# Security Configuration #
############################


variable "mgmt_nsg_display_name" {
  description = "Management Network Security Group Name"
  default     = "mgmt-security-group"
}

variable "mgmt_nsg_source_cidr" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "0.0.0.0/0"
}


variable "mgmt_nsg_ssh_port" {
  description = "SSH Port"
  default     = 22
}

variable "mgmt_nsg_http_port" {
  description = "HTTP Port"
  default     = 80
}

variable "mgmt_nsg_https_port" {
  description = "HTTPS Port"
  default     = 443
}

variable "wan_nsg_display_name" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "wan-security-group"
}

variable "wan_nsg_source_cidr" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "0.0.0.0/0"
}


variable "wan_nsg_strategy_ingress" {
  description = "Choose Network Security Rules Strategy for Ingress traffic"
  default     = "Block all ports"
}

variable "wan_nsg_strategy_egress" {
  description = "Choose Network Security Rules Strategy for Egress traffic"
  default     = "Open all ports"
}

variable "lan_nsg_display_name" {
  description = "LAN Network Security Group Name"
  default     = "lan-security-group"
}

variable "lan_nsg_source_cidr" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "0.0.0.0/0"
}


variable "lan_nsg_strategy_ingress" {
  description = "Choose Network Security Rules Strategy for Ingress traffic"
  default     = "Block all ports"
}

variable "lan_nsg_strategy_egress" {
  description = "Choose Network Security Rules Strategy for Egress traffic"
  default     = "Open all ports"
}




############################
# Additional Configuration #
############################

variable "compute_compartment_ocid" {
  description = "Compartment where Compute and Marketplace subscription resources will be created"
}

variable "network_compartment_ocid" {
  description = "Compartment where Network resources will be created"
}


variable "tag_key_name" {
  description = "Free-form tag key name"
  default     = "project"
}

variable "tag_value" {
  description = "Free-form tag value"
  default     = "fortigate-simple"
}


######################
#    Enum Values     #
######################
variable "network_strategy_enum" {
  type = map
  default = {
    CREATE_NEW_VCN_SUBNET   = "Create New VCN and Subnet"
    USE_EXISTING_VCN_SUBNET = "Use Existing VCN and Subnet"
  }
}

variable "subnet_type_enum" {
  type = map
  default = {
    PRIVATE_SUBNET = "Private Subnet"
    PUBLIC_SUBNET  = "Public Subnet"
  }
}

variable "nsg_config_enum" {
  type = map
  default = {
    BLOCK_ALL_PORTS = "Block all ports"
    OPEN_ALL_PORTS  = "Open all ports"
    CUSTOMIZE       = "Customize ports - Post deployment"
  }
}

