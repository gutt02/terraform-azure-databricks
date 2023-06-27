# Terraform - Azure - Databricks - Connectivity Landing Zone

## Table of Contents

* [Introduction](#introduction)
* [Variables](#variables)
* [Output](#output)
* [Module Shared](#module-shared)
  * [Azure Resources](#azure-resources)
  * [Variables](#variables-1)
  * [Output](#output-1)
* [Module DNS Private Resolver](#module-dns-private-resolver)
  * [Azure Resources](#azure-resources-1)
  * [Variables](#variables-2)
  * [Output](#output-2)
* [Module Virtual Network Gateway](#module-virtual-network-gateway)
  * [Azure Resources](#azure-resources-2)
  * [Variables](#variables-3)
  * [Output](#output-3)

## Introduction

This is a collection of Terraform scripts that can be used to create the Connectivity Landing Zone for the Azure Databricks.

## Variables

```hcl
variable "agent_ip" {
  type        = string
  description = "IP of the deployment agent."
}
```

```hcl
variable "client_ip" {
  type = object({
    name             = string
    cidr             = string
    start_ip_address = string
    end_ip_address   = string
  })

  description = "Client IP."
}
```

```hcl
variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal."
}
```

```hcl
variable "enable_module_dns_private_resolver" {
  type        = bool
  default     = true
  description = "Enable DNS Private Resolver."
}
```

```hcl
variable "enable_module_virtual_network_gateway" {
  type        = bool
  default     = true
  description = "Enable Virtual Network Gateway."
}
```

```hcl
variable "global_settings" {
  type    = any
  default = {
    azurecaf_name = {
      prefixes = ["az", "cf", "clz"]
    }
  }

  description = "Global settings."
}
```

```hcl
variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}
```

```hcl
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
```

```hcl
variable "private_dns_zones" {
  type = map(string)

  default = {
    dns_zone_azuredatabricks = "privatelink.azuredatabricks.net"
    dns_zone_blob            = "privatelink.blob.core.windows.net"
    dns_zone_dfs             = "privatelink.dfs.core.windows.net"
  }

  description = "Map of private DNS zones."
}
```

```hcl
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
```

```hcl
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

  description = "VNET details."
}
```

```hcl
variable "virtual_network_gateway" {
  type = object({
    type          = string
    vpn_type      = string
    active_active = optional(bool)
    enable_bgp    = optional(bool)
    sku           = string

    vpn_client_configuration = object({
      address_space        = list(string)
      vpn_client_protocols = list(string)

      root_certificate = object({
        name = string
      })
    })
  })

  default = {
    type     = "Vpn"
    vpn_type = "RouteBased"
    sku      = "VpnGw1"

    vpn_client_configuration = {
      address_space        = ["192.168.255.0/27"]
      vpn_client_protocols = ["IkeV2", "OpenVPN"]

      root_certificate = {
        name = "VnetGatewayConfig"
      }
    }
  }

  description = "Virtual network gateway details."
}
```

## Output

```hcl
output "gateway_subnet_id" {
  value = module.shared.gateway_subnet_id
}
```

```hcl
output "private_dns_zone_ids" {
  value = module.shared.private_dns_zone_ids
}
```

```hcl
output "virtual_network_id" {
  value = module.shared.virtual_network_id
}
```

## Module Shared

### Azure Resources

* Resource Group
* Virtual Network and Subnets
* Private DNS zones

### Variables

### Output

## Module DNS Private Resolver

> This module is optional.

### Azure Resources

* DNS Private Resolver

### Variables

```hcl
variable "global_settings" {
  type        = any
  description = "Global settings."
}
```

```hcl
variable "location" {
  type        = string
  description = "Default Azure region, use Azure CLI notation."
}
```

```hcl
variable "dns_private_resolver_inbound_subnet_id" {
  type        = string
  description = "Id of the inbound subnet for the DNS Private Resolver."
}
```

```hcl
variable "dns_private_resolver_outbound_subnet_id" {
  type        = string
  description = "Id of the outbound subnet for the DNS Private Resolver."
}
```

## Module Virtual Network Gateway

> This module is optional.

### Azure Resources

* Virtual Network Gateway

### Variables

```hcl
variable "global_settings" {
  type = any
  description = "Global settings."
}
```

```hcl
variable "location" {
  type        = string
  description = "Default Azure region, use Azure CLI notation."
}
```

```hcl
variable "gateway_subnet_id" {
  type        = string
  description = "Id of the Gateway Subnet."
}
```

```hcl
variable "virtual_network_gateway" {
  type = object({
    type          = string
    vpn_type      = string
    active_active = optional(bool)
    enable_bgp    = optional(bool)
    sku           = string

    vpn_client_configuration = object({
      address_space        = list(string)
      vpn_client_protocols = list(string)

      root_certificate = object({
        name = string
      })
    })
  })

  description = "Virtual network gateway details."
}
```
