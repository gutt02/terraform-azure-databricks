variable "client_config" {
  type        = any
  description = "Configuration of the AzureRM provider."
}

variable "subscription" {
  type        = any
  description = "Information about an existing Subscription."
}

variable "databricks_access_connector" {
  type        = any
  description = "Azure Databricks access connector."
}

variable "databricks_catalog" {
  type        = any
  description = "Azure Databricks catalog."
}

variable "databricks_schema" {
  type        = any
  description = "Azure Databricks catalog / schema."
}

variable "databricks_workspace" {
  type        = any
  description = "The Azure Databricks workspace."
}

variable "storage_account_id" {
  type = string
  description = "Id of the Storage Account for the meta data."
}
