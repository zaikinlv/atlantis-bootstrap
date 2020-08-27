# GCP variables
variable "org_id" {
  type        = string
  description = "Google organization ID"
  default     = ""
}

variable "project_name" {
  type        = string
  description = "The name of the GCP project created for Atlantis resources"
}

variable "billing_account" {
  type        = string
  description = "Billing account ID"
}

variable "labels" {
  type        = map(string)
  description = "Labels to use on the project"
  default     = {}
}

variable "folder_id" {
  type        = string
  description = "The ID of a folder to host this project"
  default     = ""
}

variable "project_id_prefix" {
  type        = string
  default     = ""
  description = "Project prefix ID of the Atlantis project."
}

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

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "The list of CIDR blocks of master authorized networks"
}


# Ingress variables

variable "zone_name" {
  type        = string
  description = "DNS zone name"
}

variable "resource_group" {
  type        = string
  description = "Azure resource group name"
}

# Atlantis Github variables

variable "create_secret" {
  type        = string
  default     = false
  description = "Used to trigger creation of gh-atlantis secrets"
}

variable "gh-webhook-secret" {
  type        = string
  description = "Github Webhook secret"
}

variable "gh-key-file" {
  type        = string
  description = "Github App key"
}
