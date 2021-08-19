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

variable "mp_listing_id" {
  default     = "ocid1.appcataloglisting.oc1..aaaaaaaavvijdvafj64pj5y45k7qgda2um7qdsunr6snzl2456s5isvyuaoq"
  description = "Marketplace Listing OCID"
}

variable "mp_listing_resource_id" {
  default     = "ocid1.image.oc1..aaaaaaaarfh2a6c6nsbwzrngzd23u5upj5ukzwz2bsegudd3var4evdhqtbq"
  description = "Marketplace Listing Image OCID"
}

variable "mp_listing_resource_version" {
  default     = "7.0.0_SR-IOV_Paravirtualized_Mode"
  description = "Marketplace Listing Package/Resource Version"
}

############################
#  Compute Configuration   #
############################

variable "vm_display_name" {
  description = "Instance Name"
  default     = "FortiGate"
}

variable "vm_display_name_web" {
  description = "Instance Name"
  default     = "web-app"
}

variable "vm_display_name_db" {
  description = "Instance Name"
  default     = "db-app"
}

variable "vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.4" //4 cores
}

variable "spoke_vm_compute_shape" {
  description = "Compute Shape"
  default     = "VM.Standard2.2" //2 cores
}

variable "vm_flex_shape_ocpus" {
  description = "Flex Shape OCPUs"
  default     = 4
}

variable "spoke_vm_flex_shape_ocpus" {
  description = "Spoke VMs Flex Shape OCPUs"
  default     = 4
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
  description = "SSH Public Key String"
}

variable "instance_launch_options_network_type" {
  description = "NIC Attachment Type"
  default     = "PARAVIRTUALIZED"
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

variable "web_vcn_id" {
  default = ""
}


variable "db_vcn_id" {
  default = ""
}


variable "vcn_display_name" {
  description = "VCN Name"
  default     = "firewall-vcn"
}

variable "vcn_cidr_block" {
  description = "VCN CIDR"
  default     = "192.168.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS Label"
  default     = "ha"
}

variable "subnet_span" {
  description = "Choose between regional and AD specific subnets"
  default     = "Regional Subnet"
}

variable "mangement_subnet_id" {
  default = ""
}

variable "mangement_subnet_display_name" {
  description = "Management Subnet Name"
  default     = "mgmt-subnet"
}

variable "mangement_subnet_cidr_block" {
  description = "Management Subnet CIDR"
  default     = "192.168.1.0/24"
}

variable "mangement_subnet_dns_label" {
  description = "Management Subnet DNS Label"
  default     = "management"
}

variable "trust_subnet_id" {
  default = ""
}

variable "trust_subnet_display_name" {
  description = "Trust Subnet Name"
  default     = "trust-subnet"
}

variable "trust_subnet_cidr_block" {
  description = "Trust Subnet CIDR"
  default     = "192.168.2.0/24"
}

variable "trust_subnet_dns_label" {
  description = "Trust Subnet DNS Label"
  default     = "trust"
}

variable "untrust_subnet_id" {
  default = ""
}

variable "untrust_subnet_display_name" {
  description = "Firewall Untrust Subnet Name"
  default     = "untrust-subnet"
}

variable "untrust_subnet_cidr_block" {
  description = "Firewall Untrust Subnet CIDR"
  default     = "192.168.3.0/24"
}

variable "untrust_subnet_dns_label" {
  description = "Untrust Subnet DNS Label"
  default     = "untrust"
}

variable "ha_subnet_id" {
  default = ""
}

variable "ha_subnet_display_name" {
  description = "HA Subnet Name"
  default     = "ha-subnet"
}

variable "ha_subnet_cidr_block" {
  description = "HA Subnet CIDR"
  default     = "192.168.4.0/24"
}

variable "ha_subnet_dns_label" {
  description = "HA Subnet DNS Label"
  default     = "ha"
}

variable "dynamic_group_description" {
  description = "Dynamic Group to Support FortiGate HA"
  default     = "Dynamic Group to Support FortiGate HA"
}

variable "dynamic_group_name" {
  description = "Dynamic Group Name"
  default     = "fortigate-ha-dynamic-group"
}

variable "dynamic_group_policy_description" {
  description = "Dynamic Group Policy to allow FortiGate HA floating IP switch"
  default     = "Dynamic Group Policy for FortiGate HA"
}

variable "dynamic_group_policy_name" {
  description = "Dynamic Group Policy FortiGate"
  default     = "fortigate-ha-dynamic-group-policy"
}

variable "web_vcn_cidr_block" {
  description = "Web Spoke VCN CIDR Block"
  default     = "10.0.0.0/24"
}

variable "web_vcn_dns_label" {
  description = "Web Spoke VCN DNS Label"
  default     = "web"
}

variable "web_vcn_display_name" {
  description = "Web Spoke VCN Display Name"
  default     = "web-vcn"
}

variable "web_transit_subnet_id" {
  default = ""
}

variable "web_transit_subnet_cidr_block" {
  description = "Web Spoke VCN Private Subnet"
  default     = "10.0.0.0/25"
}

variable "web_transit_subnet_display_name" {
  description = "Web Spoke VCN Private Subnet Display Name"
  default     = "application-private"
}

variable "web_transit_subnet_dns_label" {
  description = "Web Spoke VCN DNS Label"
  default     = "webtransit"
}

variable "db_vcn_cidr_block" {
  description = "DB Spoke VCN CIDR Block"
  default     = "10.0.1.0/24"
}

variable "db_vcn_dns_label" {
  description = "DB Spoke VCN DNS Label"
  default     = "db"
}

variable "db_vcn_display_name" {
  description = "DB Spoke VCN Display Name"
  default     = "db-vcn"
}

variable "db_transit_subnet_id" {
  default = ""
}

variable "db_transit_subnet_cidr_block" {
  description = "DB Spoke VCN Private Subnet"
  default     = "10.0.1.0/25"
}

variable "db_transit_subnet_display_name" {
  description = "DB Spoke VCN Private Subnet Display Name"
  default     = "database-private"
}

variable "db_transit_subnet_dns_label" {
  description = "Web Spoke VCN DNS Label"
  default     = "dbtransit"
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

variable "nsg_whitelist_ip" {
  description = "Network Security Groups - Whitelisted CIDR block for ingress communication: Enter 0.0.0.0/0 or <your IP>/32"
  default     = "0.0.0.0/0"
}

variable "nsg_display_name" {
  description = "Network Security Groups - Name"
  default     = "cluster-security-group"
}

variable "web_nsg_display_name" {
  description = "Network Security Groups - Web"
  default     = "web-security-group"
}

variable "db_nsg_display_name" {
  description = "Network Security Groups - App"
  default     = "db-security-group"
}


variable "public_routetable_display_name" {
  description = "Public route table Name"
  default     = "UntrustRouteTable"
}

variable "ha_routetable_display_name" {
  description = "HA route table Name"
  default     = "HARouteTable"
}

variable "private_routetable_display_name" {
  description = "Private route table Name"
  default     = "TrustRouteTable"
}

variable "drg_routetable_display_name" {
  description = "DRG route table Name"
  default     = "DRGRouteTable"
}

variable "sgw_routetable_display_name" {
  description = "SGW route table Name"
  default     = "SGWRouteTable"
}

variable "use_existing_ip" {
  description = "Use an existing permanent public ip"
  default     = "Create new IP"
}

variable "template_name" {
  description = "Template name. Should be defined according to deployment type"
  default     = "fortigate-drg-ha"
}

variable "template_version" {
  description = "Template version"
  default     = "20210701"
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
    transit_subnet    = "Private Subnet"
    MANAGEMENT_SUBENT = "Public Subnet"
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


variable "bootstrap_vm-a" {
  default = "./config-drg/bootstrap_vm-a.tpl"
}


variable "bootstrap_vm-b" {
 default = "./config-drg/bootstrap_vm-b.tpl"
}


######################
#    Static Values     #   
######################
#ACTIVE NODE
variable "mgmt_private_ip_primary_a" {
  description = "Primary Firewall Mgmt Interface Private IP"
  default = "192.168.1.10"
}

variable "untrust_private_ip_primary_a" {
  description = "Primary Firewall Untrust Interface Private IP"
  default = "192.168.3.10"
}

variable "trust_private_ip_primary_a" {
  description = "Primary Firewall Trust Interface Private IP"
  default = "192.168.2.10"
}

variable "hb_private_ip_primary_a" {
  description = "Primary Firewall HA Interface Private IP"
  default = "192.168.4.10"
}

#PASSIVE NODE
variable "mgmt_private_ip_primary_b" {
  description = "Secondary Firewall Mgmt Interface Private IP"
  default = "192.168.1.20"
}

variable "untrust_private_ip_primary_b" {
  description = "Secondary Firewall Untrust Interface Private IP"
  default = "192.168.3.20"
}

variable "trust_private_ip_primary_b" {
  description = "Secondary Firewall Trust Interface Private IP"
  default = "192.168.2.20"
}

variable "hb_private_ip_primary_b" {
  description = "Secondary Firewall HA Interface Private IP"
  default = "192.168.4.20"
}

variable "untrust_floating_private_ip" {
  description = "Firewall Untrust Interface Floating Private IP"
  default = "192.168.3.30"
}

variable "trust_floating_private_ip" {
  description = "Firewall Trust Interface Floating Private IP"
  default = "192.168.2.30"
}

variable "mgmt_subnet_gateway" {
  description = "Mgmt Subnet Default Gateway IP"
  default = "192.168.1.1"
}

variable "trust_subnet_gateway" {
  description = "Trust Subnet Default Gateway IP"
  default = "192.168.2.1"
}

variable "untrust_subnet_gateway" {
  description = "Untrust Subnet Default Gateway IP"
  default = "192.168.3.1"
}

variable "untrust_public_ip_lifetime" {
  description = "Public IP Address Reservation Type"
  default = "RESERVED"
}

variable "volume_size" {
  description = "Firewall VM Block Volume Attachment Size in GB"
  default = "50" //GB
}
