#---------------------------------#
# Create GCP project for Atlantis #
#---------------------------------#

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 13.0"

  name              = var.project_name
  project_id        = var.project_id_prefix
  random_project_id = "true"
  org_id            = var.org_id
  activate_apis     = var.activate_apis
  folder_id         = var.folder_id
  labels            = var.labels
  billing_account   = var.billing_account
}
