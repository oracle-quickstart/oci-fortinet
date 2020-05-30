data "oci_identity_availability_domain" "ad_primary" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number_primary
}

data "oci_identity_availability_domain" "ad_secondary" {
  compartment_id = var.tenancy_ocid
  ad_number      = var.availability_domain_number_secondary
}

data "oci_core_images" "autonomous_ol7" {
  compartment_id   = var.compute_compartment_ocid
  operating_system = "Oracle Autonomous Linux"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
  state            = "AVAILABLE"

  # filter restricts to pegged version regardless of region
  filter {
    name   = "display_name"
    values = ["Oracle-Autonomous-Linux-7.8-2020.04-0"]
    regex  = false
  }

  # filter restricts to OL 7
  filter {
    name   = "operating_system_version"
    values = ["7\\.[0-9]"]
    regex  = true
  }
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}