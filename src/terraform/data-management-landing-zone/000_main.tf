terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.58.0"
    }

    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "2.0.0-preview3"
    }

    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azurerm" {
  alias           = "connectivity_landing_zone"
  subscription_id = local.connectivity_landing_zone_subscription_id

  features {}
}

provider "azurecaf" {}

provider "databricks" {
  host                        = module.azure_databricks_workspace.databricks_workspace.workspace_url
  azure_workspace_resource_id = module.azure_databricks_workspace.databricks_workspace.id
  azure_client_id             = data.azurerm_client_config.client_config.client_id
  azure_client_secret         = var.client_secret
  azure_tenant_id             = data.azurerm_client_config.client_config.tenant_id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "client_config" {
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "subscription" {
}

module "shared" {
  source = "./modules/shared"

  providers = {
    azurerm.connectivity_landing_zone = azurerm.connectivity_landing_zone
  }

  agent_ip                                  = var.agent_ip
  client_ip                                 = var.client_ip
  client_secret                             = var.client_secret
  connectivity_landing_zone_virtual_network = data.azurerm_virtual_network.connectivity_landing_zone
  global_settings                           = var.global_settings
  location                                  = var.location
  tags                                      = var.tags
  use_remote_gateways                       = var.use_remote_gateways
  virtual_network                           = var.virtual_network
}

module "azure_databricks_workspace" {
  source = "./modules/azure_databricks_workspace"

  providers = {
    azurerm.connectivity_landing_zone = azurerm.connectivity_landing_zone
  }

  agent_ip                                                   = var.agent_ip
  client_ip                                                  = var.client_ip
  client_secret                                              = var.client_secret
  connectivity_landing_zone_private_dns_zone_azuredatabricks = data.azurerm_private_dns_zone.azuredatabricks
  databricks_private_network_security_group_association      = module.shared.databricks_private_network_security_group_association
  databricks_private_subnet                                  = module.shared.databricks_private_subnet
  databricks_public_network_security_group_association       = module.shared.databricks_public_network_security_group_association
  databricks_public_subnet                                   = module.shared.databricks_public_subnet
  enable_private_endpoints                                   = var.enable_private_endpoints
  global_settings                                            = var.global_settings
  location                                                   = var.location
  private_endpoints_subnet                                   = module.shared.private_endpoints_subnet
  tags                                                       = var.tags
  virtual_network                                            = module.shared.virtual_network

  depends_on = [module.shared]
}

module "azure_databricks_metastore" {
  source = "./modules/azure_databricks_metastore"

  count = var.enable_metastore ? 1 : 0

  providers = {
    azurerm.connectivity_landing_zone = azurerm.connectivity_landing_zone
  }

  agent_ip                                        = var.agent_ip
  client_ip                                       = var.client_ip
  client_secret                                   = var.client_secret
  connectivity_landing_zone_private_dns_zone_blob = var.connectivity_landing_zone_private_dns_zone_blob_id
  connectivity_landing_zone_private_dns_zone_dfs  = var.connectivity_landing_zone_private_dns_zone_dfs_id
  databricks_workspace                            = module.azure_databricks_workspace.databricks_workspace
  enable_private_endpoints                        = var.enable_private_endpoints
  global_settings                                 = var.global_settings
  location                                        = var.location
  metastore_name                                  = var.metastore_name
  private_endpoints_subnet                        = module.shared.private_endpoints_subnet
}
