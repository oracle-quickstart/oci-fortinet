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
  type = object({
    listing_id = string
    versions = map(object({
      image_ocid = string
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
  default     = "fortigate-ha"
}

variable "vm_license_key" {
  description = "FortiGate License Key"
  default     = ""
}

variable "path_license_file-primary" {
  description = "Path to FortiGate License Key File (.lic)"
  default     = ""
}

variable "path_license_file-secondary" {
  description = "Path to FortiGate License Key File (.lic)"
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

variable "availability_domain_name_primary" {
  default     = ""
  description = "Availability Domain"
}

variable "availability_domain_name_secondary" {
  default     = ""
  description = "Availability Domain"
}

variable "availability_domain_number_primary" {
  default     = 1
  description = "OCI Availability Domains: 1,2,3  (subject to region availability)"
}


variable "availability_domain_number_secondary" {
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

variable "hostname_label-primary" {
  default     = "fortigate1"
  description = "DNS Hostname Label. Must be unique across all VNICs in the subnet and comply with RFC 952 and RFC 1123."
}

variable "hostname_label-secondary" {
  default     = "fortigate2"
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
  default     = "fortigate-ha"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "fortigatevcn"
}

variable "mgmt_subnet_type" {
  description = "Choose between private and public subnets"
  default     = "Public Subnet"
}

variable "untrust_subnet_type" {
  description = "Choose between private and public subnets"
  default     = "Public Subnet"
}

variable "trust_subnet_type" {
  description = "Choose between private and public subnets"
  default     = "Private Subnet"
}

variable "ha_subnet_type" {
  description = "Choose between private and public subnets"
  default     = "Private Subnet"
}

variable "mgmt_subnet_id" {
  default = ""
}

variable "untrust_subnet_id" {
  default = ""
}

variable "trust_subnet_id" {
  default = ""
}

variable "ha_subnet_id" {
  default = ""
}


variable "mgmt_subnet_display_name" {
  description = "Management Subnet Name"
  default     = "management"
}

variable "mgmt_subnet_cidr_block" {
  description = "MGMT Subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "mgmt_private_ip-primary" {
  description = "Management Private IP (static)"
  default     = "10.0.1.10"
}

variable "mgmt_private_ip-secondary" {
  description = "Management Private IP (static)"
  default     = "10.0.1.20"
}

variable "mgmt_subnet_dns_label" {
  description = "Subnet DNS Label"
  default     = "management"
}

variable "trust_subnet_display_name" {
  description = "Trust Subnet Name"
  default     = "trust"
}

variable "trust_subnet_cidr_block" {
  description = "Trust Subnet CIDR"
  default     = "10.0.10.0/24"
}

variable "trust_floating_private_ip" {
  description = "Floating IP used during HA Failover (static)"
  default     = "10.0.10.10"
}

variable "trust_subnet_dns_label" {
  description = "Trust Subnet DNS Label"
  default     = "trust"
}


variable "untrust_subnet_display_name" {
  description = "Untrust Subnet Name"
  default     = "untrust"
}

variable "untrust_subnet_cidr_block" {
  description = "Untrust Subnet CIDR"
  default     = "10.0.100.0/24"
}

variable "untrust_floating_private_ip" {
  description = "Floating IP used during HA Failover (static)"
  default     = "10.0.100.10"
}

variable "untrust_subnet_dns_label" {
  description = "Untrust Subnet DNS Label"
  default     = "untrust"
}

variable "ha_subnet_display_name" {
  description = "HA Subnet Name"
  default     = "ha"
}

variable "ha_subnet_cidr_block" {
  description = "HA Subnet CIDR"
  default     = "10.0.200.0/24"
}

variable "ha_private_ip-primary" {
  description = "HA Private IP (static)"
  default     = "10.0.200.10"
}

variable "ha_private_ip-secondary" {
  description = "HA Private IP (static)"
  default     = "10.0.200.20"
}

variable "ha_subnet_dns_label" {
  description = "HA Subnet DNS Label"
  default     = "ha"
}




############################
# Security Configuration #
############################

variable "mgmt_sec_list_display_name" {
  description = "Management Security List Name"
  default     = "mgmt-security-list"

}

variable "trust_sec_list_display_name" {
  description = "Trust Security List Name"
  default     = "trust-security-list"

}

variable "untrust_sec_list_display_name" {
  description = "Untrust Security List Name"
  default     = "untrust-security-list"

}

variable "ha_sec_list_display_name" {
  description = "HA Security List Name"
  default     = "ha-security-list"

}

variable "mgmt_sec_rule_source_cidr" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "0.0.0.0/0"
}


variable "mgmt_sec_rule_ssh_port" {
  description = "SSH Port"
  default     = 22
}

variable "mgmt_sec_rule_http_port" {
  description = "HTTP Port"
  default     = 80
}

variable "mgmt_sec_rule_https_port" {
  description = "HTTPS Port"
  default     = 443
}


variable "untrust_sec_rule_source_cidr" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "0.0.0.0/0"
}

variable "untrust_sec_strategy_ingress" {
  description = "Choose Network Security Rules Strategy for Ingress traffic"
  default     = "Block all ports"
}

variable "untrust_sec_strategy_egress" {
  description = "Choose Network Security Rules Strategy for Egress traffic"
  default     = "Open all ports"
}


variable "trust_sec_rule_source_cidr" {
  description = "Allowed Ingress Traffic (CIDR Block)"
  default     = "0.0.0.0/0"
}


variable "trust_sec_strategy_ingress" {
  description = "Choose Network Security Rules Strategy for Ingress traffic"
  default     = "Block all ports"
}

variable "trust_sec_strategy_egress" {
  description = "Choose Network Security Rules Strategy for Egress traffic"
  default     = "Open all ports"
}




############################
# Additional Configuration #
############################

variable "ha_iam_dynamic_group_name" {
  description = "IAM HA Dynamic Group Name"
  default     = "fortigate-ha-instances"
}

variable "ha_iam_dynamic_group_description" {
  description = "IAM HA Dynamic Description"
  default     = "Dynamic Group containing FortiGate HA cluster instances"
}


variable "ha_iam_policy_name" {
  description = "IAM FortiGate HA Policy Name"
  default     = "allow-fortigate-ha-failover"
}

variable "ha_iam_policy_description" {
  description = "IAM Policy Description"
  default     = "Policies to allow FortiGate node to move floating IPs"
}


variable "compute_compartment_ocid" {
  description = "Compartment where Compute and Marketplace subscription resources will be created"
}

variable "network_compartment_ocid" {
  description = "Compartment where Network resources will be created"
}

variable "iam_compartment_ocid" {
  description = "Compartment where IAM policies will be created"
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

