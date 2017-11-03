# azcycle
Cycle Server on Azure scripts and templates

# Create Azure Resources

* Clone the repo 

        git clone https://github.com/jermth/azcycle.git

* Update vnet-params.json and vms-params.json files with your values

* Create a resource group

        az group create --name "my-group" --location "West Europe"

* Build the Virtual Network and subnets. By default the vnet is named **cyclevnet** . Update the **{githubuser}** value with your github user name

        az group deployment create --name "vnet_deployment" --resource-group "my-group" --template-uri https://raw.githubusercontent.com/{githubuser}/azcycle/master/deploy-vnet.json --parameters vnet-params.json

* Build the VMs. Update the **{githubuser}** value with your github user name

        az group deployment create --name "vnet_deployment" --resource-group "my-group" --template-uri https://raw.githubusercontent.com/{githubuser}/azcycle/master/deploy-vms.json --parameters vms-params.json


# Configure Cycle Server

## Activate your Cycle License 
To connect to the Cycle Portal, first retrieve the FQDN of the CycleServer VM from the Azure Portal, then browse to http://cycleserverfqdn/

Create an admin user named **cycleadmin** 

Claim your license or activate your license. Once activated, don't add a cloud provider, this will be added later from the CLI.

## Setup CycleCloud CLI
The Cycle Server is not directly accessible, you have to use the admin jumpbox to reach it.
In the Azure portal, retrieve the full DNS name of the admin jump box. You can then SSH on it with the **cycleadmin** user and the SSH key you provided. Once on the jumbox 

    ssh cycleserver

* Initialize CycleCloud CLI

create a Service Principal first or have one as explained here https://docs.cyclecomputing.com/installation-guide-v6.6.0/configuring_cloud_provider/masetup then start the initialize process 

        cyclecloud initialize


## Check installation logs

The Cycle Server installation logs are located in the /var/lib/waagent/custom-script/download/0 directory.

# Create your cluster

Build your cluster in Cycle by using the provided templates

