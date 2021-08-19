# ------ Create Dynamic Group to Support FortiGate Firewall HA
resource "oci_identity_dynamic_group" "fortigate_dynamic_group" {
  compartment_id = var.tenancy_ocid
  name           = var.dynamic_group_name
  description    = var.dynamic_group_description
  matching_rule  = "Any {instance.id = '${oci_core_instance.vm-a[0].id}', instance.id = '${oci_core_instance.vm-b[0].id}'}" 
}

# ------ Create Dynamic Group Policies to Support FortiGate Firewall
resource "oci_identity_policy" "fortigate_firewall_ha_policy" {
  compartment_id = var.tenancy_ocid
  description    = var.dynamic_group_policy_description
  name           = var.dynamic_group_policy_name

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.fortigate_dynamic_group.name} to manage all-resources in TENANCY"
  ]
}