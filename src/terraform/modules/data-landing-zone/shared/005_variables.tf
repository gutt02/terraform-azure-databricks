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

variable "connectivity_landing_zone_virtual_network_id" {
  type        = string
  description = "Virutal Network Id of of the connectivity landing zone"
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

variable "private_dns_zones" {
  type = map(string)

  default = {
    dns_zone_azuredatabricks = "privatelink.azuredatabricks.net"
  }

  description = "Map of private DNS zones."
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
    address_space = "192.168.20.0/23"
    subnets = {
      private_endpoints = {
        name          = "private-endpoints"
        address_space = "192.168.20.0/26"
      }
      databricks_public = {
        name          = "databricks-public"
        address_space = "192.168.20.64/26"
      }
      databricks_private = {
        name          = "databricks-private"
        address_space = "192.168.20.128/26"
      }
    }
  }

  description = "VNET destails."
}
