terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
    }

    azurecaf = {
      source = "aztfmod/azurecaf"
    }

    databricks = {
      source = "databricks/databricks"
    }
  }
}
