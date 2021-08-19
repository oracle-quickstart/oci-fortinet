# FortiGate HA Cluster using DRG - Reference Architecture

We are using hub-and-spoke architecture (often called as star topology), dynamic routing gateway with FortiGate Firewall. This architecture has a central component (the hub) that's connected to multiple networks around it, like a spoke. We are using Fortinet's FortiGate firewall PAID Listing from OCI Marketplace.

For details of the architecture, see [_Set up a hub-and-spoke network topology_](https://docs.oracle.com/en/solutions/hub-spoke-network/index.html).

## Architecture Diagram

![](./images/arch.png)

## Validated Version Details

We have validated 7.0.0_SR-IOV_Paravirtualized_Mode FortiGate Firewall for this architecture.
- Chose **Create New VCN and Subnet** strategy. 

## Prerequisites

You should complete below pre-requisites before proceeding to next section:
- You have an active Oracle Cloud Infrastructure Account.
  - Tenancy OCID, User OCID, Compartment OCID, Private and Public Keys are setup properly.
- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `security-lists`,`dynamic-routing-gateways`, `subnets` and `instances`.
- Quota to create the following resources: 3 VCNS, 6 subnets, and 6 compute instance.
- Access to FortiGate Paid listing on OCI Marektplace. 

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).


## Deployment Options

You can deploy this architecture using two approach explained in each section: 
1. Using Oracle Resource Manager 
2. Using Terraform CLI 

## Deploy Using Oracle Resource Manager

In this section you will follow each steps given below to create this architecture:

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://console.us-phoenix-1.oraclecloud.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-quickstart/oci-fortinet/raw/master/use-case/drg-ha-use-case//resource-manager/fortigate-drg-ha.zip)

    > If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan** from the stack on OCI console UI.

6. Wait for the job to be completed, and review the plan.

    > To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

8. If you no longer require your infrastructure, return to the Stack Details page and **Terraform Actions**, and select **Destroy**.


## Deploy Using the Terraform CLI

In this section you will use **Terraform** locally to create this architecture: 


1. Create a local copy of this repo using below command on your terminal: 

    ```
    git clone https://github.com/oracle-quickstart/oci-fortinet.git
    cd oci-fortinet/use-cases/drg-ha-use-case/
    ls
    ```

2. Complete the prerequisites described [here] which are associated to install **Terraform** locally:(https://github.com/oracle-quickstart/oci-prerequisites#install-terraform).
    Make sure you have terraform v0.13+ cli installed and accessible from your terminal.

    ```bash
    terraform -v

    Terraform v0.13.0
    + provider.oci v4.14.0
    ```

3. Create a `terraform.tfvars` file in your **drg-ha-use-case** directory, and specify the following variables:

    ```
    # Authentication
    tenancy_ocid         = "<tenancy_ocid>"
    user_ocid            = "<user_ocid>"
    fingerprint          = "<finger_print>"
    private_key_path     = "<pem_private_key_pem_file_path>"

    # SSH Keys
    ssh_public_key  = "<public_ssh_key_string_value>"

    # Region
    region = "<oci_region>"

    # Compartment
    compute_compartment_ocid = "<compartment_ocid>"
    network_compartment_ocid = "<network_compartment_ocid>"
    availability_domain_number = "<availability_domain_number>

    ````

4. Create the Resources using the following commands:

    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

5. At this stage your architecture should have been deployed successfully. You can proceed to next section for configuring your FortiGate Firewall. 

6. If you no longer require your infrastructure, you can run this command to destroy the resources:

    ```bash
    terraform destroy
    ```

## FortiGate Firewall Configuration 

This section will include necessary configuration which you need to configure to support active/active use-case. 

Once you deploy the infrastructure either using Oracle Resource Manager or Terraform CLI. You have to ensure that correct configuration is applied/configured on FortiGate Firewalls. 


> You can also manage FortiGate Firewalls configuration using FortiManager.

You can connect to FortiGate GUI using below steps: 

```
1.  In a web browser, 
    - Connect to the Fortigate Firewall GUI Firewall-1: https://${oci_core_instance.vm-a.0.public_ip}
    - Connect to the Fortigate Firewall GUI Firewall-2: https://${oci_core_instance.vm-b.0.public_ip}
2. Use admin/<instance_ocid> to connect to Firewall Instances. 
```

You can follow [this workshop](https://apexapps.oracle.com/pls/apex/dbpm/r/livelabs/view-workshop?wid=846) or Fortinet Deployment guide to support your use-case: 

- This Workshop cover HA deployement on OCI. You can follow **Lab3** and **Lab4** to get yourself familiar with FortiGate configuration. 
- You can also follow FortiGate deployment guide. 

## Some Useful Configuration Pics on FortiGate Firewall 

I am attaching some sample configuration from one of the Firewall-B for your reference as below: 

1. Interfaces Configuration 
    - Ethernet1/1 ; Trust Interface 
    - Ethernet1/2 ; Untrust Interface 

![](./images/interfaces.png)


2. Security Policies 
    - Untrust to Trust and Vice Versa 
    - Intra Zone Policies 

![](./images/policies.png)


3. Default Routes Configuration 
    - Default route via untrust interface gateway (port2)
    - Static Routes for Spoke VCNs and Oracle Storage Networks via trust interface gateway (port3)

![](./images/routes.png)

## Need Fixes

Below fixes are needed:
- Validate cloud-init part to support initial configuration on Firewall VMs.

## Feedback 

Feedbacks are welcome to this repo, please open a PR if you have any.