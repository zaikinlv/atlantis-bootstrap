#------------------#
# Google Providers #
#------------------#
# `GOOGLE_APPLICATION_CREDENTIALS` must be set in the environment before Terraform is run.

provider "google" {
  # Terraform will check the `GOOGLE_APPLICATION_CREDENTIALS` variable, so no `credentials`
  # value is needed here.
  version = "~> 3.27.0"
}


#-----------------#
# Azure Providers #
#-----------------#

provider "azurerm" {
  version = "~> 2.21.0"
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id

  # Make the AzureRM Provider skip registering any required Resource Providers
  # The reason we do this is because the client does not have the necessary
  # privileges to register a resource provider.
  # https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview
  skip_provider_registration = true
}


#------------------#
# GitHub providers #
#------------------#
provider github {
  version = "2.9.2"
}
