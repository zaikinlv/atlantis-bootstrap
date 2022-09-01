variable "project_name" {
  type        = string
  description = "The name of the GCP project created for Atlantis resources"
}

variable "project_id_prefix" {
  type        = string
  default     = ""
  description = "Project prefix ID of the Atlantis project."
}

variable "org_id" {
  type        = string
  description = "Google organization ID"
  default     = ""
}

variable "activate_apis" {
  type        = list(string)
  description = "The list of APIs to activate within the project"
}

variable "folder_id" {
  type        = string
  description = "The ID of a folder to host this project"
  default     = ""
}

variable "labels" {
  type        = map(string)
  description = "Labels to use on the project"
  default     = {}
}

variable "billing_account" {
  type        = string
  description = "Billing account ID"
}
