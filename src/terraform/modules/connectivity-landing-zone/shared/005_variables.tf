# curl ipinfo.io/ip
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

variable "global_settings" {
  default = {
    azurecaf_name = {
      prefixes = ["az", "cf", "clz"]
    }
  }
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}

variable "on_premises_networks" {
  type = list(object({
    name             = string
    cidr             = string
    start_ip_address = string
    end_ip_address   = string
  }))

  default = [
    {
      name             = "AllowFromOnPremises1"
      cidr             = "10.0.0.0/24"
      start_ip_address = "10.0.0.0"
      end_ip_address   = "10.0.0.255"
    }
  ]

  description = "List of on premises networks."
}

variable "private_dns_zones" {
  type = map(string)

  default = {
    dns_zone_azuredatabricks = "privatelink.azuredatabricks.net"
    dns_zone_blob            = "privatelink.blob.core.windows.net"
    dns_zone_dfs             = "privatelink.dfs.core.windows.net"
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
    project     = "Connectivity Landing Zone"
  }

  description = "Default tags for resources, only applied to resource groups"
}


variable "virtual_network" {
  type = object({
    address_space = string

    subnets = map(object({
      address_space       = string
      client_address_pool = optional(string)
      description         = optional(string)
    }))
  })

  default = {
    address_space = "192.168.0.0/24"
    subnets = {
      gateway = {
        address_space       = "192.168.0.0/27"
        client_address_pool = "192.168.255.0/27"
        description         = "GatewaySubnet"
      }
      bastion = {
        name          = "AzureBastionSubnet"
        address_space = "192.168.0.32/27"
      }
      private_endpoints = {
        address_space = "192.168.0.64/27"
        description   = "Private Endpoints"
      }
      dns_private_resolver_inbound = {
        address_space = "192.168.0.96/28"
        description   = "DNS Private Resolver Outbound"
      }
      dns_private_resolver_outbound = {
        address_space = "192.168.0.112/28"
        description   = "DNS Private Resolver Inbound"
      }
    }
  }

  description = "VNET destails."
}
