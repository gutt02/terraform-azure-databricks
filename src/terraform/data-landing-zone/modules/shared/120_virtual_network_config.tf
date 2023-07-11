# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
resource "azurerm_network_security_rule" "databricks_private" {
  count = var.enable_private_endpoints ? 1 : 0

  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureDatabricks"
  resource_group_name         = local.resource_group.name
  network_security_group_name = azurerm_network_security_group.databricks_private.name
  description                 = "Required for workers communication with Databricks Webapp."
}

resource "azurerm_network_security_rule" "databricks_public" {
  count = var.enable_private_endpoints ? 1 : 0

  name                        = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "AzureDatabricks"
  resource_group_name         = local.resource_group.name
  network_security_group_name = azurerm_network_security_group.databricks_public.name
  description                 = "Required for workers communication with Databricks Webapp."
}
