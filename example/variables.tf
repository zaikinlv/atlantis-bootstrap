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

# Atlantis Github variables

variable "gh-webhook-secret" {
  type        = string
  description = "Github Webhook secret"
}

variable "gh-key-file" {
  type        = string
  description = "Github App key"
}
