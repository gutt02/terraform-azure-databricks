# Terraform - Azure - Databricks - Data Landing Zone

## Table of Contents

* [Introduction](#introduction)
* [Variables](#variables)
* [Output](#output)
* [Module Shared](#module-shared)
  * [Azure Resources](#azure-resources)
  * [Variables](#variables-1)
  * [Output](#output-1)
* [Module Azure Databricks Workspace](#module-azure-databricks-workspace)
  * [Azure Resources](#azure-resources-1)
  * [Variables](#variables-2)
  * [Output](#output-2)
* [Module Azure Databricks Metastore](#module-azure-databricks-metastore)
  * [Azure Resources](#azure-resources-2)
  * [Variables](#variables-3)
  * [Output](#output-3)

## Introduction

This is a collection of Terraform scripts that can be used to create the Data Management Landing Zone in the Azure Databricks environment.

> The Service Principal must have been assigend the role `account_admin` before the Metastore can be created.

The deployment is performed in three steps:

1. Creation of the shared services and the Databricks Workspace, set the variable `enable_metastore` to `false`.
2. Assign the role `admin_account` to the Service Principal.  
  2.1. Login with a Global Admin to the Azure Databricks Workspace.  
  2.2. Go to the Admin Account, menu upper right corner.  
  2.3. Under User Management, select Service Principal and assign role `admin_account` to the Service Principal.  
  2.4. Use the script `databricks-rest-api\scripts\databricks_api.rest` if needed.
3. Creation of the Metastore, set the variable `enable_metastore` to `true`.

> TODO: Detailed documentation to follow.

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
variable "connectivity_landing_zone_private_dns_zone_azuredatabricks_id" {
  type        = string
  description = "Id of the private dns zone for Azure Databricks in the connectivity subscription."
}
```

```hcl
variable "connectivity_landing_zone_private_dns_zone_blob_id" {
  type        = string
  description = "Id of theprivate dns zone for BLOBs in the connectivity subscription."
}
```

```hcl
variable "connectivity_landing_zone_private_dns_zone_dfs_id" {
  type        = string
  description = "Id of the private dns zone for Data Lake File system in the connectivity subscription."
}
```

```hcl
variable "connectivity_landing_zone_virtual_network_id" {
  type        = string
  description = "Virutal Network Id of of the connectivity landing zone."
}
```

```hcl
variable "enable_metastore" {
  type        = bool
  default     = false
  description = "Enable Databricks metastore, ensure that the service principal has the role admin_account in the Databricks account."
}
```

```hcl
variable "enable_private_endpoints" {
  type        = bool
  default     = true
  description = "Enable private endpoints."
}
```

```hcl
variable "global_settings" {
  type = any
  default = {
    azurecaf_name = {
      prefixes = ["az", "cf", "dmz"]
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
variable "metastore_name" {
  type        = string
  default     = "metastore-euw"
  description = "Name of the Databricks Metastore."
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
    project     = "Data Management Zone"
  }

  description = "Default tags for resources, only applied to resource groups."
}
```

```hcl
variable "use_remote_gateways" {
  type        = bool
  default     = true
  description = "Use remote gateways in peering."
}
```

```hcl
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

  description = "VNET details."
}
```

## Output

```hcl
output "databricks_metastore" {
  value = try(module.azure_databricks_metastore[0].databricks_metastore, "unavailable")
}
```

## Module Shared

### Azure Resources

* Resource Group
* Virtual Network and Subnets.

### Variables

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
variable "connectivity_landing_zone_virtual_network" {
  type        = any
  description = "Virutal Network of of the connectivity landing zone."
}
```

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
```

```hcl
variable "use_remote_gateways" {
  type        = bool
  description = "Use remote gateways in peering."
}
```

```hcl
variable "virtual_network" {
  type = object({
    address_space = string

    subnets = map(object({
      name          = string
      address_space = string
    }))
  })

  description = "VNET details."
}
```

### Output

```hcl
output "private_endpoints_subnet" {
  value = azurerm_subnet.private_endpoints
}
```

```hcl
output "databricks_public_subnet" {
  value = azurerm_subnet.databricks_public
}
```

```hcl
output "databricks_private_subnet" {
  value = azurerm_subnet.databricks_private
}
```

```hcl
output "databricks_public_network_security_group_association" {
  value = azurerm_subnet_network_security_group_association.databricks_public
}
```

```hcl
output "databricks_private_network_security_group_association" {
  value = azurerm_subnet_network_security_group_association.databricks_private
}
```

```hcl
output "virtual_network" {
  value = azurerm_virtual_network.this
}
```

## Module Azure Databricks Workapce

### Azure Resources

* Resource Group
* Azure Databricks Workspace
* Private Endpoints

### Variables

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
variable "connectivity_landing_zone_private_dns_zone_azuredatabricks" {
  type        = any
  description = "The private dns zone for Azure Databricks in the connectivity subscription."
}
```

```hcl
variable "databricks_private_network_security_group_association" {
  type        = any
  description = "The databricks private network security association."
}
```

```hcl
variable "databricks_private_subnet" {
  type        = any
  description = "The databricks private subnet."
}
```

```hcl
variable "databricks_public_network_security_group_association" {
  type        = any
  description = "The databricks public network security association"
}
```

```hcl
variable "databricks_public_subnet" {
  type        = any
  description = "The databricks public subnet."
}
```

```hcl
variable "enable_private_endpoints" {
  type        = bool
  description = "Enable private endpoints."
}
```

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
variable "private_endpoints_subnet" {
  type        = any
  description = "The private endpoints subnet."
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

  description = "Default tags for resources, only applied to resource groups."
}
```

```hcl
variable "virtual_network" {
  type        = any
  description = "The virtual network"
}
```

### Output

```hcl
output "databricks_workspace" {
  value = azurerm_databricks_workspace.this
}
```

## Module Azure Databricks Metastore

### Azure Resources

* Azure Storage Account
* Databricks Access Connector
* Databricks Metastore

### Variables

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
variable "connectivity_landing_zone_private_dns_zone_blob" {
  type        = any
  description = "The private dns zone for BLOBs in the connectivity subscription."
}
```

```hcl
variable "connectivity_landing_zone_private_dns_zone_dfs" {
  type        = any
  description = "The private dns zone for Data Lake File system in the connectivity subscription."
}
```

```hcl
variable "databricks_workspace" {
  type        = any
  description = "The Azure Databricks workspace."
}
```

```hcl
variable "enable_private_endpoints" {
  type        = bool
  description = "Enable private endpoints."
}
```

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
variable "metastore_name" {
  type        = string
  default     = "metastore-euw"
  description = "Name of the Databricks Metastore."
}
```

```hcl
variable "private_endpoints_subnet" {
  type        = any
  description = "The private endpoints subnet."
}
```

### Output

```hcl
output "databricks_metastore" {
  value = databricks_metastore.this
}
```
