# azcycle
Cycle Server on Azure scripts and templates

## Pre-requisites
1. Valid [CycleCloud portal](http://portal.cyclecomputing.com) account

2. [Azure CLI 2.0](https://docs.microsoft.com/en-us/cli/azure/overview?view=azure-cli-latest) installed and configured with an Azure subscription

3. [Service principal in your Azure Active Directory](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest)

Essentially:
```

        $ az ad sp create-for-rbac --name CycleCloudApp --years 1

Save the output -- you'll need the appId, password and tenant id.
        {
                "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                "displayName": "CycleCloudApp",
                "name": "http://CycleCloudApp",
                "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
                "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        }
```
4. Azure subscription ID. 

The easiest way to retrieve it:
        $ az account list -o table



## Create Azure Resources

* Clone the repo 

        git clone https://github.com/{githubuser}/azcycle.git

* Update vnet-params.json and vms-params.json files with your values

* Create a resource group

        az group create --name "my-group" --location "West Europe"

* Build the Virtual Network and subnets. By default the vnet is named **cyclevnet** . Update the **{githubuser}** value with your github user name

        az group deployment create --name "vnet_deployment" --resource-group "my-group" --template-uri https://raw.githubusercontent.com/{githubuser}/azcycle/master/deploy-vnet.json --parameters vnet-params.json

* Build the VMs. Update the **{githubuser}** value with your github user name

        az group deployment create --name "vnet_deployment" --resource-group "my-group" --template-uri https://raw.githubusercontent.com/{githubuser}/azcycle/master/deploy-vms.json --parameters vms-params.json


## Configure Cycle Server

## Activate your Cycle License 
To connect to the CycleCloud webserver, first retrieve the FQDN of the CycleServer VM from the Azure Portal, then browse to http://cycleserverfqdn/

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

