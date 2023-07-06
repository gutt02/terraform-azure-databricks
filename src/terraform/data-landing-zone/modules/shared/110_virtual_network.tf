# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "vnet" {
  resource_type = "azurerm_virtual_network"
  prefixes      = var.global_settings.azurecaf_name.prefixes
}

resource "azurecaf_name" "private_endpoints" {
  resource_type  = "azurerm_subnet"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  suffixes       = ["private-endpoints"]
  resource_types = ["azurerm_network_security_group"]
}

resource "azurecaf_name" "databricks_public" {
  resource_type  = "azurerm_subnet"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  suffixes       = ["databricks-public"]
  resource_types = ["azurerm_network_security_group"]
}

resource "azurecaf_name" "databricks_private" {
  resource_type  = "azurerm_subnet"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  suffixes       = ["databricks-private"]
  resource_types = ["azurerm_network_security_group"]
}

resource "azurecaf_name" "dlz_to_clz" {
  resource_type = "azurerm_virtual_network_peering"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["clz"]
}

resource "azurecaf_name" "clz_to_dlz" {
  resource_type = "azurerm_virtual_network_peering"
  prefixes      = var.global_settings.azurecaf_name.prefixes
  suffixes      = ["dlz"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "this" {
  name                = azurecaf_name.vnet.result
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.virtual_network.address_space]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "private_endpoints" {
  name                 = azurecaf_name.private_endpoints.result
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.virtual_network.subnets.private_endpoints.address_space]
  //enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.AzureCosmosDB",
    "Microsoft.CognitiveServices",
    "Microsoft.EventHub",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus",
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.Web"
  ]
}

resource "azurerm_subnet" "databricks_public" {
  name                 = azurecaf_name.databricks_public.result
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.virtual_network.subnets.databricks_public.address_space]

  delegation {
    name = "Microsoft.Databricks.workspaces"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }

  service_endpoints = [
    "Microsoft.Storage"
  ]
}

resource "azurerm_subnet" "databricks_private" {
  name                 = azurecaf_name.databricks_private.result
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.virtual_network.subnets.databricks_private.address_space]

  delegation {
    name = "Microsoft.Databricks.workspaces"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }

  service_endpoints = [
    "Microsoft.Storage"
  ]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "private_endpoints" {
  name                = azurecaf_name.private_endpoints.results["azurerm_network_security_group"]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_group" "databricks_public" {
  name                = azurecaf_name.databricks_public.results["azurerm_network_security_group"]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_network_security_group" "databricks_private" {
  name                = azurecaf_name.databricks_private.results["azurerm_network_security_group"]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.private_endpoints.id
}

resource "azurerm_subnet_network_security_group_association" "databricks_public" {
  subnet_id                 = azurerm_subnet.databricks_public.id
  network_security_group_id = azurerm_network_security_group.databricks_public.id
}

resource "azurerm_subnet_network_security_group_association" "databricks_private" {
  subnet_id                 = azurerm_subnet.databricks_private.id
  network_security_group_id = azurerm_network_security_group.databricks_private.id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering
resource "azurerm_virtual_network_peering" "dlz_to_clz" {
  name                      = azurecaf_name.dlz_to_clz.result
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.connectivity_landing_zone_virtual_network.id
  use_remote_gateways       = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "clz_to_dlz" {
  provider = azurerm.connectivity_landing_zone

  name                      = azurecaf_name.clz_to_dlz.result
  resource_group_name       = var.connectivity_landing_zone_virtual_network.resource_group_name
  virtual_network_name      = var.connectivity_landing_zone_virtual_network.name
  remote_virtual_network_id = azurerm_virtual_network.this.id
  allow_gateway_transit     = var.use_remote_gateways

  depends_on = [
    azurerm_virtual_network_peering.dlz_to_clz
  ]
}

