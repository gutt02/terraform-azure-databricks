# Terraform - Azure - Databricks

## Table of Contents

* [Introduction](#introduction)
* [Pre-Requirements](#pre-requirements)
* [Landing Zones](#landing-zones)
* [Resources](#resources)

## Introduction

This is a collection of Terraform scripts that can be used to create Azure Databricks environment including Unity Catalog with Metastore, catalog, groups and permissions. Please check the [Resources](#resources) for full documentations provided by Microsoft.

## Azure Infrastructure

![Azure Infrastructure Connectivity Landing Zone](./doc/images/AzureInfrastructureDatabricks.png)

## Pre-Requirements

* Service Principal
* Remote Backend
* [terraform-azure-setup-remote-backed](https://github.com/gutt02/terraform-azure-setup-remote-backend)

## Landing Zones

* [Connectivity Landing Zone](./src/terraform/connectivity-landing-zone/README.md)
* [Data Management Landing Zone](./src/terraform/data-management-landing-zone/README.md)
* [Data Landing Zone](./src/terraform/data-landing-zone/README.md)

## Resources

* [Cloud-scale analytics - Microsoft Cloud Adaption Framework for Azure](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics/)
* [Azure Databricks Documentation](https://learn.microsoft.com/en-us/azure/databricks/)
* [Enable Azure Private Link as a standard deployment](https://learn.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/private-link-standard)
* [What is Unity Catalog?](https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/)
* [Configure SCIM provisioning using Microsoft Azure Active Directory](https://learn.microsoft.com/en-us/azure/databricks/administration-guide/users-groups/scim/aad)
* [Metastore limits and resource quotas](https://learn.microsoft.com/en-us/azure/databricks/release-notes/unity-catalog/20220825#metastore-limits-and-resource-quotas)
* [Azure Databricks REST API reference](https://docs.databricks.com/api/azure/workspace/introduction)
* [Generate and export certificates for point-to-site using PowerShell](https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site)