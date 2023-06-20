variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal."
}

variable "connectivity_landing_zone_private_dns_zone_blob_id" {
  type        = string
  description = "Id of the private dns zone for BLOBs in the connectivity subscription."
}

variable "connectivity_landing_zone_private_dns_zone_dfs_id" {
  type        = string
  description = "Id of the private dns zone for Data Lake File system in the connectivity subscription."
}

variable "databricks_account_id" {
  type        = string
  description = "The Id of Databricks Account."
}

variable "databricks_metastore_id" {
  type        = string
  description = "The Databricks Metastore Id."
}

variable "databricks_resource_id" {
  type        = string
  description = "The Azure resource Id for the Azure Databricks workspace."
}

variable "global_settings" {
  default = {
    azurecaf_name = {
      prefixes = ["az", "cf", "dlz"]
    }
  }
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}

variable "private_endpoints_subnet_id" {
  type        = string
  description = "Id of the private endpoints subnet."
}

variable "tags" {
  type = object({
    created_by  = string
    contact     = string
    customer    = string
    environment = string
    project     = string
  })

  default = {
    created_by  = "azc-iac-acf-sp-tf"
    contact     = "contact@me"
    customer    = "Azure"
    environment = "Cloud Foundation"
    project     = "Data Landing Zone"
  }

  description = "Default tags for resources, only applied to resource groups"
}
