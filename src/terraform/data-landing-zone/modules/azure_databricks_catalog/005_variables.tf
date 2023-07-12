variable "client_config" {
  type        = any
  description = "Configuration of the AzureRM provider."
}

variable "subscription" {
  type        = any
  description = "Information about an existing Subscription."
}

variable "agent_ip" {
  type        = string
  description = "IP of the deployment agent."
}

variable "client_ip" {
  type = object({
    name             = string
    cidr             = string
    start_ip_address = string
    end_ip_address   = string
  })

  description = "Client IP."
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal."
}

variable "catalog_name" {
  type        = string
  description = "Name of the catalog."
}

variable "container_name" {
  type        = string
  description = "Name of the storage account container."
}

variable "databricks_metastore_id" {
  type        = string
  description = "The Databricks Metastore Id."
}

variable "databricks_workspace" {
  type        = any
  description = "The Azure Databricks workspace."
}

variable "enable_private_endpoints" {
  type        = bool
  default     = true
  description = "Enable private endpoints."
}

variable "global_settings" {
  type        = any
  description = "Global settings."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}

variable "resource_group" {
  type        = any
  description = "Resource group."
}

variable "schema_name" {
  type        = string
  description = "Name of the schema."
}

variable "storage_account" {
  type        = any
  description = "Storage account for the catalg."
}
