terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      version = "~> 3.27.0"
      source  = "hashicorp/google"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.21.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    github = {
      source  = "hashicorp/github"
      version = "2.9.2"
    }
  }
}
