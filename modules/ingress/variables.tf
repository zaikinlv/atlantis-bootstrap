variable "project_id" {
  type        = string
  default     = ""
  description = "Project ID of the Atlantis project."
}

variable "region" {
  type        = string
  default     = "europe-north1"
  description = "Region in which to create the cluster and run Atlantis."
}

variable "project_id_prefix" {
  type        = string
  default     = ""
  description = "Project prefix ID of the Atlantis project."
}

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
