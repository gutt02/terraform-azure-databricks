### https://docs.databricks.com/dev-tools/api/latest/index.html
### https://learn.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/aad/service-prin-aad-token#get-token-azure-cli

### Use a Service Principal
export CLIENT_ID="********-****-****-****-************"
export CLIENT_SECRET="****************************************"
export SUBSCRIPTION_ID="********-****-****-****-************"
export TENANT_ID="********-****-****-****-************"
az login --service-principal --username ${CLIENT_ID} --password ${CLIENT_SECRET} --tenant ${TENANT_ID}

### Use Azure AD User
az login --tenant ${TENANT_ID} --use-device-code

### Get Token for the Databricks Service, the resource is fix
az account get-access-token --resource 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d
