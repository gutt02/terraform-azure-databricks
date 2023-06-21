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

variable "connectivity_landing_zone_private_dns_zone_blob_id" {
  type        = string
  description = "Id of the private dns zone for BLOBs in the connectivity subscription."
}

variable "connectivity_landing_zone_private_dns_zone_dfs_id" {
  type        = string
  description = "Id of the private dns zone for Data Lake File system in the connectivity subscription."
}

variable "databricks_resource_id" {
  type        = string
  description = "The Azure resource Id for the Azure Databricks workspace."
}

variable "enable_private_endpoints" {
  type        = bool
  default     = true
  description = "Enable private endpoints."
}

variable "global_settings" {
  default = {
    azurecaf_name = {
      prefixes = ["az", "cf", "dmz"]
    }
  }
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}

variable "metastore_name" {
  type        = string
  default     = "metastore-euw"
  description = "Name of the Databricks Metastore."
}

variable "private_endpoints_subnet_id" {
  type        = string
  description = "Id of the private endpoints subnet."
}
