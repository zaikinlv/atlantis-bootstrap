variable "project_id" {
  type        = string
  default     = ""
  description = "Project ID of the Atlantis project."
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "Cluster name of the Kubernetes cluster"
}

variable "azure_client_secret" {
  type        = string
  description = "Azure client secret"
}

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

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "The list of CIDR blocks of master authorized networks"
}
