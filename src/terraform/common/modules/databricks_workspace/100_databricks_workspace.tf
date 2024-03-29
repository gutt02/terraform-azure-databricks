# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "databricks_workspace" {
  resource_type = "azurerm_databricks_workspace"
  prefixes      = var.global_settings.azurecaf_name.prefixes
}

resource "azurecaf_name" "storage_account" {
  resource_type = "azurerm_storage_account"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["db", "managed"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace
resource "azurerm_databricks_workspace" "this" {
  name                = azurecaf_name.databricks_workspace.result
  location            = var.location
  resource_group_name = var.resource_group.name

  custom_parameters {
    no_public_ip                                         = var.enable_private_endpoints ? true : false
    public_subnet_name                                   = var.databricks_public_subnet.name
    public_subnet_network_security_group_association_id  = var.databricks_public_network_security_group_association.id
    private_subnet_name                                  = var.databricks_private_subnet.name
    private_subnet_network_security_group_association_id = var.databricks_private_network_security_group_association.id
    storage_account_name                                 = azurecaf_name.storage_account.result
    virtual_network_id                                   = var.virtual_network.id
  }

  managed_resource_group_name           = "${var.resource_group.name}-managed"
  network_security_group_rules_required = var.enable_private_endpoints ? "NoAzureDatabricksRules" : null
  public_network_access_enabled         = var.enable_private_endpoints ? false : true
  sku                                   = "premium"
}
