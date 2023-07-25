terraform {
  backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.62.0"
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
  host                        = module.databricks_workspace.databricks_workspace.workspace_url
  azure_workspace_resource_id = module.databricks_workspace.databricks_workspace.id
  azure_client_id             = data.azurerm_client_config.this.client_id
  azure_client_secret         = var.client_secret
  azure_tenant_id             = data.azurerm_client_config.this.tenant_id
}

provider "databricks" {
  alias               = "azure_account"
  host                = "https://accounts.azuredatabricks.net"
  account_id          = var.databricks_account_id
  azure_client_id     = data.azurerm_client_config.this.client_id
  azure_client_secret = var.client_secret
  azure_tenant_id     = data.azurerm_client_config.this.tenant_id
  # auth_type  = "azure-cli"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "this" {
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "this" {
}

module "resource_group_network" {
  source = "../common/modules/resource_group"

  client_config   = data.azurerm_client_config.this
  subscription    = data.azurerm_subscription.this
  global_settings = merge(var.global_settings, { azurecaf_name = { prefixes = var.global_settings.azurecaf_name.prefixes, suffixes = ["network"] } })
  location        = var.location
  tags            = var.tags
}

module "shared" {
  source = "./modules/shared"

  providers = {
    azurerm.connectivity_landing_zone = azurerm.connectivity_landing_zone
  }

  client_config                             = data.azurerm_client_config.this
  subscription                              = data.azurerm_subscription.this
  agent_ip                                  = var.agent_ip
  client_ip                                 = var.client_ip
  client_secret                             = var.client_secret
  connectivity_landing_zone_virtual_network = data.azurerm_virtual_network.this
  enable_private_endpoints                  = var.enable_private_endpoints
  global_settings                           = var.global_settings
  location                                  = var.location
  private_dns_zones                         = var.private_dns_zones
  resource_group                            = module.resource_group_network.resource_group
  use_remote_gateways                       = var.use_remote_gateways
  virtual_network                           = var.virtual_network
}

module "resource_group_databricks_workspace" {
  source = "../common/modules/resource_group"

  client_config   = data.azurerm_client_config.this
  subscription    = data.azurerm_subscription.this
  global_settings = merge(var.global_settings, { azurecaf_name = { prefixes = var.global_settings.azurecaf_name.prefixes, suffixes = ["dbw"] } })
  location        = var.location
  tags            = var.tags
}

module "databricks_workspace" {
  source = "../common/modules/databricks_workspace"

  providers = {
    azurerm.connectivity_landing_zone = azurerm.connectivity_landing_zone
  }

  client_config                                         = data.azurerm_client_config.this
  subscription                                          = data.azurerm_subscription.this
  databricks_private_network_security_group_association = module.shared.databricks_private_network_security_group_association
  databricks_private_subnet                             = module.shared.databricks_private_subnet
  databricks_public_network_security_group_association  = module.shared.databricks_public_network_security_group_association
  databricks_public_subnet                              = module.shared.databricks_public_subnet
  enable_private_endpoints                              = var.enable_private_endpoints
  global_settings                                       = var.global_settings
  location                                              = var.location
  private_dns_zone_azuredatabricks_backend              = try(module.shared.private_dns_zones["azuredatabricks"], null)
  private_dns_zone_azuredatabricks_frontend             = try(data.azurerm_private_dns_zone.this["azuredatabricks"], null)
  private_endpoints_subnet                              = module.shared.private_endpoints_subnet
  resource_group                                        = module.resource_group_databricks_workspace.resource_group
  virtual_network                                       = module.shared.virtual_network

  depends_on = [module.shared]
}

module "key_vault" {
  source = "../common/modules/key_vault"

  client_config              = data.azurerm_client_config.this
  subscription               = data.azurerm_subscription.this
  agent_ip                   = var.agent_ip
  client_ip                  = var.client_ip
  private_dns_zones          = data.azurerm_private_dns_zone.this
  enable_private_endpoints   = var.enable_private_endpoints
  global_settings            = var.global_settings
  location                   = var.location
  private_endpoints_subnet   = module.shared.private_endpoints_subnet
  resource_group             = module.resource_group_databricks_workspace.resource_group
  virtual_network_subnet_ids = [module.shared.databricks_private_subnet.id, module.shared.databricks_public_subnet.id]
}

module "resource_group_storage" {
  source = "../common/modules/resource_group"

  client_config   = data.azurerm_client_config.this
  subscription    = data.azurerm_subscription.this
  global_settings = merge(var.global_settings, { azurecaf_name = { prefixes = var.global_settings.azurecaf_name.prefixes, suffixes = ["storage"] } })
  location        = var.location
  tags            = var.tags
}

module "storage_account_data" {
  source = "../common/modules/storage_account"

  client_config              = data.azurerm_client_config.this
  subscription               = data.azurerm_subscription.this
  agent_ip                   = var.agent_ip
  client_ip                  = var.client_ip
  private_dns_zones          = data.azurerm_private_dns_zone.this
  enable_private_endpoints   = var.enable_private_endpoints
  global_settings            = merge(var.global_settings, { azurecaf_name = { prefixes = var.global_settings.azurecaf_name.prefixes, suffixes = ["data"] } })
  location                   = var.location
  private_endpoints_subnet   = module.shared.private_endpoints_subnet
  resource_group             = module.resource_group_storage.resource_group
  virtual_network_subnet_ids = concat([module.shared.databricks_private_subnet.id, module.shared.databricks_public_subnet.id], coalesce(var.databricks_serverless_sql_subnets, []))

  depends_on = [module.shared]
}

module "databricks_access_connector" {
  source = "../common/modules/databricks_access_connector"

  client_config   = data.azurerm_client_config.this
  subscription    = data.azurerm_subscription.this
  global_settings = var.global_settings
  location        = var.location
  resource_group  = module.resource_group_databricks_workspace.resource_group
}

module "storage_account_uc" {
  source = "../common/modules/storage_account"

  client_config              = data.azurerm_client_config.this
  subscription               = data.azurerm_subscription.this
  agent_ip                   = var.agent_ip
  client_ip                  = var.client_ip
  private_dns_zones          = data.azurerm_private_dns_zone.this
  enable_private_endpoints   = var.enable_private_endpoints
  global_settings            = merge(var.global_settings, { azurecaf_name = { prefixes = var.global_settings.azurecaf_name.prefixes, suffixes = ["uc"] } })
  location                   = var.location
  private_endpoints_subnet   = module.shared.private_endpoints_subnet
  resource_group             = module.resource_group_databricks_workspace.resource_group
  virtual_network_subnet_ids = concat([module.shared.databricks_private_subnet.id, module.shared.databricks_public_subnet.id], coalesce(var.databricks_serverless_sql_subnets, []))
}

# Wait for the creations of the groups and the assignment of the grants
resource "time_sleep" "delay_catalog_deployment" {
  count = var.enable_catalog ? 1 : 0

  depends_on = [
    databricks_grants.this,
    azurerm_role_assignment.this,
    azurerm_role_assignment.uc,
    databricks_group_member.this
  ]

  create_duration = "5s"
}

module "azure_databricks_catalog" {
  source = "../common/modules/databricks_catalog"

  for_each = {
    for o in var.unity_catalog.catalogs : o.name => o if var.enable_catalog
  }

  databricks_catalog             = each.value
  databricks_access_connector_id = module.databricks_access_connector.databricks_access_connector.id
  databricks_metastore_id        = var.unity_catalog.metastore.id
  grants                         = var.unity_catalog.grants
  owner                          = each.value.owner != null ? each.value.owner : data.azurerm_client_config.this.client_id
  storage_account_id             = each.value.storage_account_id != null ? each.value.storage_account_id : module.storage_account_uc.storage_account.id

  depends_on = [time_sleep.delay_catalog_deployment]
}
