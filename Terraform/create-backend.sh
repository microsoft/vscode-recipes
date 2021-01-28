#!/bin/bash

RESOURCE_GROUP=$1
STORAGE_ACCOUNT=$2
CONTAINER=$3
LOCATION=$4

# create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# create storage account
az storage account create --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT --sku Standard_LRS --encryption-services blob

# create blob container for tf state files
az storage container create --name $CONTAINER --account-name $STORAGE_ACCOUNT --auth-mode login

echo $RESOURCE_GROUP
echo $STORAGE_ACCOUNT
echo $CONTAINER
