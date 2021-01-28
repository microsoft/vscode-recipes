set RESOURCE_GROUP=%1
set STORAGE_ACCOUNT=%2
set CONTAINER=%3
set LOCATION=%4

REM create resource group
call az group create --name %RESOURCE_GROUP% --location %LOCATION%

REM create storage account
call az storage account create --resource-group %RESOURCE_GROUP% --name %STORAGE_ACCOUNT% --sku Standard_LRS --encryption-services blob

REM get storage account key
call az storage account keys list --resource-group %RESOURCE_GROUP% --account-name %STORAGE_ACCOUNT% --query [0].value -o tsv >storageKey.txt
set /p ACCOUNT_KEY=<storageKey.txt
del storageKey.txt

REM create blob container for tf state files
call az storage container create --name %CONTAINER% --account-name %STORAGE_ACCOUNT% --account-key %ACCOUNT_KEY%

echo %RESOURCE_GROUP%
echo %STORAGE_ACCOUNT%
echo %CONTAINER%