# azcycle
Cycle Server on Azure scripts and templates

# Setup

* Clone the repo 

        git clone https://github.com/xpillons/azcycle.git

* Update vnet-params.json and vms-params.json files with your values

* Create a resource group

        az group create --name "my-group" --location "West Europe"

* Build the Virtual Network and subnets. By default the vnet is named **cyclevnet** . Update the **{githubuser}** value with your github user name

        az group deployment create --name "vnet_deployment" --resource-group "my-group" --template-uri https://raw.githubusercontent.com/{githubuser}/azcycle/master/deploy-vnet.json --parameters vnet-params.json

* Build the VMs. Update the **{githubuser}** value with your github user name

        az group deployment create --name "vnet_deployment" --resource-group "my-group" --template-uri https://raw.githubusercontent.com/{githubuser}/azcycle/master/deploy-vms.json --parameters vms-params.json

# Connecting to the Cycle Server

The Cycle Server is not directly accessible, you have to use the admin jumpbox to reach it.
In the Azure portal, retrieve the full DNS name of the admin jump box. You can then SSH on it with the **cycleadmin** user and the SSH key you provided. Once on the jumbox 

    ssh cycleserver
 
To connect to the Cycle Portal, first retrieve the FQDN of the CycleServer VM from the Azure Portal, then browse to http://cycleserverfqdn/

# Check installation logs

The Cycle Server installation logs are located in the /var/lib/waagent/custom-script/download/0 directory.

# Configuring Cycle to use Azure

This needs to be done manually by following the online documentation of Cycle from here https://docs.cyclecomputing.com/installation-guide-v6.6.0/configuring_cloud_provider/masetup
There is no need to change the Network Security Rules and the Virtual Network, this is all done in the ARM templates provided here

