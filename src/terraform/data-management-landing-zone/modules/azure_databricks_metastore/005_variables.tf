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

variable "connectivity_landing_zone_private_dns_zone_blob" {
  type        = any
  description = "The private dns zone for BLOBs in the connectivity subscription."
}

variable "connectivity_landing_zone_private_dns_zone_dfs" {
  type        = any
  description = "The private dns zone for Data Lake File system in the connectivity subscription."
}

variable "databricks_private_subnet" {
  type        = any
  description = "The databricks private subnet."
}

variable "databricks_public_subnet" {
  type        = any
  description = "The databricks public subnet."
}

variable "databricks_workspace" {
  type        = any
  description = "The Azure Databricks workspace."
}

variable "enable_private_endpoints" {
  type        = bool
  description = "Enable private endpoints."
}

variable "resource_group" {
  type        = any
  description = "Resource group."
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

variable "private_endpoints_subnet" {
  type        = any
  description = "The private endpoints subnet."
}
