#BYOL Listing Id
variable "fortigate_version" {}

variable "mp_listing_id" {
  default = "ocid1.appcataloglisting.oc1..aaaaaaaam7ewzrjbltqiarxukuk72v2lqkdtpqtwxqpszqqvrm7likfnpt5q"
}
#Published FortiGate Versions mapped to Marketplace Resource Version Name
variable "mp_versions" {
    type = "map"
    default = {
        "6.2.0" = "6.2.0_Paravirtualized_Mode"
        "6.2.1" = "6.2.1_Paravirtualized_Mode"
    }
}
#Published FortiGate Versions mapped to Marketplace Global Image OCIDs
variable "mp_listing_resource_version_id" {
    type = "map"
    default = {
        "6.2.0_Paravirtualized_Mode" = "ocid1.image.oc1..aaaaaaaanmyvejof6g4oypjmz6blbp27uggbyb2q4oce22y7vyslvkmnyj6a"
        "6.2.1_Paravirtualized_Mode" = "ocid1.image.oc1..aaaaaaaaneyk7xuosfi66a3t7dpww5oe4sqd3ssbumsip43buq5cwedilc6q"
    }
}



data "archive_file" "mp_fortigate_byol" {
  depends_on  = ["local_file.generate_mp_variables_tf"]
  type        = "zip"
  output_path = "${path.module}/files/fortigate-${var.fortigate_version}.zip"

  source_dir = "../fortigate-single-vm"
}

data "template_file" "mp_variables_template" {
  template = "${file("${path.module}/mp_variables.tpl")}"

  vars {
    mp_listing_id               = "${var.mp_listing_id}"
    mp_listing_resource_id      = "${var.mp_versions[var.fortigate_version]}"
    mp_listing_resource_version = "${var.mp_listing_resource_version_id[var.mp_versions[var.fortigate_version]]}"
  }
}

resource "local_file" "generate_mp_variables_tf" {
    content = "${data.template_file.mp_variables_template.rendered}"
    filename = "../fortigate-single-vm/mp_fortigate-${var.fortigate_version}.tf"
}
