set RESOURCE_GROUP=%1
set STORAGE_ACCOUNT=%2
set CONTAINER=%3
set LOCATION=%4

REM create resource group
call az group create --name %RESOURCE_GROUP% --location %LOCATION%

REM create storage account
call az storage account create --resource-group %RESOURCE_GROUP% --name %STORAGE_ACCOUNT% --sku Standard_LRS --encryption-services blob

REM create blob container for tf state files
call az storage container create --name %CONTAINER% --account-name %STORAGE_ACCOUNT% --auth-mode login

echo %RESOURCE_GROUP%
echo %STORAGE_ACCOUNT%
echo %CONTAINER%