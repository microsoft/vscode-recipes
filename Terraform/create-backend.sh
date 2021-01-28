#!/bin/bash

RESOURCE_GROUP=$1
STORAGE_ACCOUNT=$2
CONTAINER=$3
LOCATION=$4

# create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# create storage account
az storage account create --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT --sku Standard_LRS --encryption-services blob

# get storage account key
ACCOUNT_KEY=`az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query [0].value -o tsv`

# create blob container for tf state files
az storage container create --name $CONTAINER --account-name $STORAGE_ACCOUNT --account-key $ACCOUNT_KEY

echo $RESOURCE_GROUP
echo $STORAGE_ACCOUNT
echo $CONTAINER