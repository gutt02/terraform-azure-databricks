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

variable "catalog_container" {
  type        = string
  default     = "catalogs"
  description = "Name of the container for the catalogs."
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

variable "databricks_account_id" {
  type        = string
  description = "The Databricks Account Id."
}

variable "unity_catalog" {
  type = object({
    groups = list(object({
      name        = string
      permissions = list(string)
    }))
    metastore = object({
      id = string
      grants = list(object({
        principal  = string
        privileges = list(string)
      }))
    })
    catalogs = list(object({
      name               = string
      container_name     = string
      owner              = optional(string)
      storage_account_id = optional(string)
      grants = list(object({
        principal = string
        privileges = object({
          catalog            = list(string)
          external_location  = optional(list(string))
          storage_credential = optional(list(string))
        })
      }))
      schemas = list(object({
        name               = string
        container_name     = string
        owner              = optional(string)
        storage_account_id = optional(string)
        grants = list(object({
          principal = string
          privileges = object({
            schema             = list(string)
            external_location  = optional(list(string))
            storage_credential = optional(list(string))
          })
        }))
      }))
    }))
  })

  description = "Databricks catalogs."
}

# https://learn.microsoft.com/en-us/azure/databricks/sql/admin/serverless-firewall
# https://learn.microsoft.com/en-us/azure/databricks/resources/supported-regions#serverless-sql-subnets
variable "databricks_serverless_sql_subnets" {
  type = list(string)
  default = [
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeurope-nephos3/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeurope-nephos4/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeurope-nephos5/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeurope-nephos6/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeurope-nephos7/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeuropec2-nephos2/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeuropec2-nephos3/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeuropec2-nephos4/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeuropec2-nephos5/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet",
    "/subscriptions/8453a5d5-9e9e-40c7-87a4-0ab4cc197f48/resourceGroups/prod-azure-westeuropec2-nephos6/providers/Microsoft.Network/virtualNetworks/kaas-vnet/subnets/worker-subnet"
  ]

  description = "Subnets for Databricks Serverless SQL, leave empty if not required."
}

variable "enable_catalog" {
  type        = bool
  default     = false
  description = "Enable Databricks catalog, ensure that the service principal has the role admin_account in the Databricks account."
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
      prefixes = ["az", "cf", "dlz"]
    }
  }

  description = "Global settings."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}

variable "private_dns_zones" {
  type = map(string)

  default = {
    azuredatabricks = "privatelink.azuredatabricks.net"
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

  description = "VNET details."
}
