variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal."
}

variable "connectivity_landing_zone_virtual_network_id" {
  type        = string
  description = "Virutal Network Id of of the connectivity landing zone"
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

  description = "Default tags for resources, only applied to resource groups"
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
    address_space = "192.168.10.0/23"
    subnets = {
      private_endpoints = {
        name          = "private-endpoints"
        address_space = "192.168.10.0/26"
      }
      databricks_public = {
        name          = "databricks-public"
        address_space = "192.168.10.64/26"
      }
      databricks_private = {
        name          = "databricks-private"
        address_space = "192.168.10.128/26"
      }
    }
  }

  description = "VNET destails."
}
