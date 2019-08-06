# FortiGate BYOL

These are Terraform modules that deploy Fortinet BYOL solutions on Oracle Cloud Infrastructure (OCI) via Marketplace.
Marketplace Terraform based solutions a.k.a. *Stacks* run on top of [Resource Manager](https://docs.cloud.oracle.com/iaas/Content/ResourceManager/Concepts/resourcemanager.htm) service and they are published via [Marketplace Partner Portal](https://partner.cloudmarketplace.oracle.com/partner/index.html).
They are developed jointly by Fortinet and Oracle.  These are a work in progress.

## Prerequisites

First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).
In order to create a Stack for a Marketplace image, publisher need to have access to the Marketplace *Listing ID, Image OCID and Resource Version*. These data are available in the Marketplace Partner's portal.

## Clone the Module

Now, you'll want a local copy of this repo by running:

    git clone https://github.com/oracle/oci-quickstart-fortinet.git


## Generate a Stack zip file

You can generate the Stack zip file automatically for FortiGate *6.2.1* by running the following commands:

```bash
cd oci-quickstart-fortinet/marketplace/byol/fortigate/mp-package-generator
terraform init
terraform plan -var="fortigate_version=6.2.1"
terraform apply -var="fortigate_version=6.2.1"
```

The output of `terraform apply` should look like:

```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

local_file.generate_mp_variables_tf: Creating...
  content:  "" => "#marketplace image variables\nvariable \"mp_listing_id\" {\n  default = \"ocid1.appcataloglisting.oc1..aaaaaaaam7ewzrjbltqiarxukuk72v2lqkdtpqtwxqpszqqvrm7likfnpt5q\"\n}\nvariable \"mp_listing_resource_id\" {\n  default = \"6.2.1_Paravirtualized_Mode\"\n}\nvariable \"mp_listing_resource_version\" {\n  default = \"ocid1.image.oc1..aaaaaaaaneyk7xuosfi66a3t7dpww5oe4sqd3ssbumsip43buq5cwedilc6q\"\n}"
  filename: "" => "../fortigate-single-vm/mp_fortigate-6.2.1.tf"
local_file.generate_mp_variables_tf: Creation complete after 0s (ID: 267f2fb615c9fff788ae1cea032a4a8cec046883)
data.archive_file.mp_fortigate_byol: Refreshing state...

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

As the result of the above commands, you will have:

* a new file `mp_fortigate-6.2.1.tf` created into the [fortigate-single-vm](../fortigate-single-vm) folder containing the variables used to subscribe to the Marketplace Image listing version.
* terraform template files packaged into `fortigate-6.2.1.zip` within the `files` folder.

You can modify the value of `fortigate_version` variable according to the version of the FortiGate listing you want to generate.

**Note: current versions 6.2.0 and 6.2.1*

## Stack Validation - Deploy to ORM

You should test a Stack directly on OCI Resource Manager service prior to publish it to Marketplace. You can create a Stack on ORM via OCI Console or [CLI](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm) by running the following commands:

```bash
cd oci-quickstart-fortinet/marketplace/byol/fortigate/mp-package-generator/files
oci resource-manager stack create –-compartment-id <compartment_OCID> 
    --config-source fortigate-6.2.1.zip --display-name "FortiGate6.2.1" 
    --description "FortiGate 6.2.1 Marketplace Stack"
```