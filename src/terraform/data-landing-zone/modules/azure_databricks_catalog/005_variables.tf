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

variable "private_endpoints_subnet" {
  type        = any
  description = "The private endpoints subnet."
}

variable "tags" {
  type = object({
    created_by  = string
    contact     = string
    customer    = string
    environment = string
    project     = string
  })

  description = "Default tags for resources, only applied to resource groups."
}
