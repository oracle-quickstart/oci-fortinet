resource "oci_identity_dynamic_group" "ha_dynamic_group" {
  provider       = oci.home_region
  compartment_id = var.tenancy_ocid
  name           = var.ha_iam_dynamic_group_name
  description    = var.ha_iam_dynamic_group_description
  matching_rule  = "ALL {instance.id = '${oci_core_instance.primary_instance.id}', instance.id = '${oci_core_instance.secondary_instance.id}'}"

  freeform_tags = map(var.tag_key_name, var.tag_value)
}

resource "oci_identity_policy" "ha_iam_policy" {
  provider       = oci.home_region
  name           = var.ha_iam_policy_name
  description    = var.ha_iam_policy_description
//   compartment_id = var.iam_compartment_ocid
compartment_id = var.tenancy_ocid
    // "Allow dynamic-group ${oci_identity_dynamic_group.ha_dynamic_group.name} to manage all-resources in compartment id ${var.compute_compartment_ocid}"
  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.ha_dynamic_group.name} to read compartments in compartment id ${var.compute_compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ha_dynamic_group.name} to read instances in compartment id ${var.compute_compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ha_dynamic_group.name} to read vnic-attachments in compartment id ${var.compute_compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ha_dynamic_group.name} to read public-ips in compartment id ${var.compute_compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.ha_dynamic_group.name} to use private-ips in compartment id ${var.compute_compartment_ocid}"
  ]

  freeform_tags = map(var.tag_key_name, var.tag_value)
}
