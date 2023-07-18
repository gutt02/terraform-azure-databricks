# https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name
resource "azurecaf_name" "vnet" {
  resource_type = "azurerm_virtual_network"
  prefixes      = var.global_settings.azurecaf_name.prefixes
}

resource "azurecaf_name" "snet_dns_private_resolver_inbound" {
  resource_type  = "azurerm_subnet"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  suffixes       = ["dnspr", "ib"]
  resource_types = ["azurerm_network_security_group"]
}

resource "azurecaf_name" "snet_dns_private_resolver_outbound" {
  resource_type  = "azurerm_subnet"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  suffixes       = ["dnspr", "ob"]
  resource_types = ["azurerm_network_security_group"]
}

resource "azurecaf_name" "snet_private_endpoints" {
  resource_type  = "azurerm_subnet"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  suffixes       = ["pe"]
  resource_types = ["azurerm_network_security_group"]
}

resource "azurecaf_name" "snet_databricks_private" {
  resource_type  = "azurerm_subnet"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  suffixes       = ["databricks-private"]
  resource_types = ["azurerm_network_security_group"]
}

resource "azurecaf_name" "snet_databricks_public" {
  resource_type  = "azurerm_subnet"
  prefixes       = var.global_settings.azurecaf_name.prefixes
  suffixes       = ["databricks-public"]
  resource_types = ["azurerm_network_security_group"]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "this" {
  name                = azurecaf_name.vnet.result
  location            = var.location
  resource_group_name = var.resource_group.name
  address_space       = [var.virtual_network.address_space]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.virtual_network.subnets.gateway.address_space]

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

resource "azurerm_subnet" "azure_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.virtual_network.subnets.bastion.address_space]
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = azurecaf_name.snet_private_endpoints.result
  resource_group_name  = var.resource_group.name
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

resource "azurerm_subnet" "dns_private_resolver_inbound" {
  name                 = azurecaf_name.snet_dns_private_resolver_inbound.result
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.virtual_network.subnets.dns_private_resolver_inbound.address_space]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

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

  lifecycle {
    ignore_changes = [
      delegation
    ]
  }
}

resource "azurerm_subnet" "dns_private_resolver_outbound" {
  name                 = azurecaf_name.snet_dns_private_resolver_outbound.result
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.virtual_network.subnets.dns_private_resolver_outbound.address_space]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }

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

  lifecycle {
    ignore_changes = [
      delegation
    ]
  }
}

resource "azurerm_network_security_group" "private_endpoints" {
  name                = azurecaf_name.snet_private_endpoints.results["azurerm_network_security_group"]
  location            = var.location
  resource_group_name = var.resource_group.name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "dns_private_resolver_inbound" {
  name                = azurecaf_name.snet_dns_private_resolver_inbound.results["azurerm_network_security_group"]
  location            = var.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_network_security_group" "dns_private_resolver_outbound" {
  name                = azurecaf_name.snet_dns_private_resolver_outbound.results["azurerm_network_security_group"]
  location            = var.location
  resource_group_name = var.resource_group.name
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "dns_private_resolver_inbound" {
  subnet_id                 = azurerm_subnet.dns_private_resolver_inbound.id
  network_security_group_id = azurerm_network_security_group.dns_private_resolver_inbound.id
}

resource "azurerm_subnet_network_security_group_association" "dns_private_resolver_outbound" {
  subnet_id                 = azurerm_subnet.dns_private_resolver_outbound.id
  network_security_group_id = azurerm_network_security_group.dns_private_resolver_outbound.id
}

resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.private_endpoints.id
}
