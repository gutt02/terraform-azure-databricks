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

variable "connectivity_landing_zone_private_dns_zone_ids" {
  type        = map(any)
  description = "Ids of the private dns zones in the connectivity subscription."
}

variable "connectivity_landing_zone_virtual_network_id" {
  type        = string
  description = "Virutal Network Id of of the connectivity landing zone."
}

variable "enable_metastore" {
  type        = bool
  default     = false
  description = "Enable Databricks metastore, ensure that the service principal has the role admin_account in the Databricks account."
}

variable "enable_private_endpoints" {
  type        = bool
  default     = true
  description = "Enable private endpoints."
}

variable "global_settings" {
  type = any
  default = {
    azurecaf_name = {
      prefixes = ["az", "cf", "dmz"]
    }
  }

  description = "Global settings."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}

variable "metastore_container" {
  type        = string
  default     = "metastore"
  description = "Name of the metastore container."
}

variable "metastore_name" {
  type        = string
  default     = "metastore-euw"
  description = "Name of the Databricks metastore."
}

variable "metastore_owner" {
  type        = string
  description = "Owner of the Databricks metastore."
}

variable "private_endpoints_subresource_names" {
  type        = list(string)
  default     = ["browser_authentication", "databricks_ui_api"]
  description = "List of subresources for the private endpoints."
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
    project     = "Data Management Zone"
  }

  description = "Default tags for resources, only applied to resource groups."
}

variable "use_remote_gateways" {
  type        = bool
  default     = true
  description = "Use remote gateways in peering."
}

variable "virtual_network" {
  type = object({
    address_space = string

    subnets = map(object({
      name          = string
      address_space = string
    }))
  })

  default = {
    address_space = "192.168.10.0/26"
    subnets = {
      private_endpoints = {
        name          = "private-endpoints"
        address_space = "192.168.10.0/28"
      }
      databricks_public = {
        name          = "databricks-public"
        address_space = "192.168.10.16/28"
      }
      databricks_private = {
        name          = "databricks-private"
        address_space = "192.168.10.32/28"
      }
    }
  }

  description = "VNET details."
}
