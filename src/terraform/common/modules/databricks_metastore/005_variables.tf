variable "client_config" {
  type        = any
  description = "Configuration of the AzureRM provider."
}

variable "subscription" {
  type        = any
  description = "Information about an existing Subscription."
}

variable "container_name" {
  type        = string
  description = "Name of the storage account container."
}

variable "databricks_access_connector" {
  type = any
  description = "Azure Databricks access connector"
}

variable "databricks_workspace" {
  type        = any
  description = "The Azure Databricks workspace."
}

variable "global_settings" {
  type        = any
  description = "Global settings."
}

variable "location" {
  type        = string
  description = "Default Azure region, use Azure CLI notation."
}

variable "metastore_name" {
  type        = string
  description = "Name of the Databricks Metastore."
}

variable "metastore_owner" {
  type        = string
  description = "Owner of the Databricks Metastore."
}

variable "resource_group" {
  type        = any
  description = "Resource group."
}

variable "storage_account" {
  type        = any
  description = "Storage account for the metastore."
}
