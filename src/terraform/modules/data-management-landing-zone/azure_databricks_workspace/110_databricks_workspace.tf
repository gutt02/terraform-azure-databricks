# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "dbw" {
  resource_type  = "azurerm_databricks_workspace"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  resource_types = ["azurerm_storage_account"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace
resource "azurerm_databricks_workspace" "this" {
  name                = azurecaf_name.dbw.result
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  custom_parameters {
    no_public_ip                                         = var.enable_private_endpoints ? true : false
    public_subnet_name                                   = data.azurerm_subnet.databricks_public.name
    public_subnet_network_security_group_association_id  = var.databricks_public_network_security_group_association_id
    private_subnet_name                                  = data.azurerm_subnet.databricks_private.name
    private_subnet_network_security_group_association_id = var.databricks_private_network_security_group_association_id
    storage_account_name                                 = azurecaf_name.dbw.results["azurerm_storage_account"]
    virtual_network_id                                   = data.azurerm_virtual_network.this.id
  }

  managed_resource_group_name           = "${azurerm_resource_group.this.name}-managed"
  network_security_group_rules_required = var.enable_private_endpoints ? "NoAzureDatabricksRules" : null
  public_network_access_enabled         = var.enable_private_endpoints ? false : true
  sku                                   = "premium"
}
