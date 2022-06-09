terraform {
  required_version = "~> 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}

data "google_client_config" "default" {
}

data "google_container_cluster" "cluster" {
  name    = "atlantis-prod"
  project = "atlantis-prod-0073"
}

provider "google" {
  zone = "europe-north1-a"
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id

  skip_provider_registration = true
}

provider "github" {
}

