terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.connectivity_landing_zone]
    }

    azurecaf = {
      source  = "aztfmod/azurecaf"
    }

    databricks = {
      source = "databricks/databricks"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "client_config" {}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "subscription" {}
