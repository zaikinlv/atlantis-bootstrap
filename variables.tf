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

variable "activate_apis" {
  type        = list(string)
  default     = [
    "container.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "iap.googleapis.com",
    "cloudkms.googleapis.com"
  ]
  description = "The list of apis to activate within the project"
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
  description = "Project prefix ID of the Atlantis project. Also used as cluster name"
}


# GKE specific variables

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "The list of CIDR blocks of master authorized networks"
}

variable "region" {
  type        = string
  default     = "europe-north1"
  description = "Region in which to create the cluster and run Atlantis."
}

variable "zone" {
  type        = string
  default     = "europe-north1-a"
  description = "GCP zone in which to create the cluster and run Atlantis"
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

variable "external_ip_name" {
  type        = string
  description = "Name of the external IP address resource in GCP"
}
