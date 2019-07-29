resource "oci_core_instance" "vm" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 1],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "fortimanager_vm"
  shape               = "${var.instance_shape}"

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.untrust_subnet.id}"
    display_name     = "untrust"
    assign_public_ip = true
    hostname_label   = "untrust"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.vm_image_ocid[var.region]}"

    //for PIC image: source_id   = "${var.vm_image_ocid}"

    # Apply this to set the size of the boot volume that's created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }

  # Apply the following flag only if you wish to preserve the attached boot volume upon destroying this instance
  # Setting this and destroying the instance will result in a boot volume that should be managed outside of this config.
  # When changing this value, make sure to run 'terraform apply' so that it takes effect before the resource is destroyed.
  #preserve_boot_volume = true


  //required for metadata setup via cloud-init
  //   metadata {
  //     ssh_authorized_keys = "${var.ssh_public_key}"
  //     user_data           = "${base64encode(file(var.BootStrapFile))}"
  //   }

  timeouts {
    create = "60m"
  }
}

