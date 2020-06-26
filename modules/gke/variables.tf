variable "project_id" {
  type        = string
  default     = ""
  description = "Project ID of the Atlantis project."
}

variable "project_id_prefix" {
  type        = string
  default     = ""
  description = "Project prefix ID of the Atlantis project."
}

variable "region" {
  type        = string
  default     = "europe-north1"
  description = "Region in which to create the cluster and run Atlantis."
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "The list of CIDR blocks of master authorized networks"
}

variable "zone" {
  type        = string
  default     = "europe-north1-a"
  description = "GCP zone in which to create the cluster and run Atlantis"
}
