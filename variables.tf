# GCP variables
variable "org_id" {}

variable "project_name" {}

variable "billing_account" {}

variable "labels" {}

variable "folder_id" {}

variable "project_id_prefix" {}

# Azure variables
variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "azure_client_id" {
  type        = string
  description = "Azure client ID"
}

variable "azure_client_secret" {
  type        = string
  description = "Azure client secret"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant ID"
}


# GKE spacific svariables

variable "master_authorized_networks" {}


# Ingress variables

variable "zone_name" {}

variable "resource_group" {}

# Atlantis Github variables

variable "create_secret" {}

variable "gh-webhook-secret" {}

variable "gh-key-file" {}
