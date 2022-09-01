data "google_client_config" "default" {
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gcp" {
  source = "./modules/gcp"

  project_name      = var.project_name
  project_id_prefix = var.project_id_prefix
  org_id            = var.org_id
  folder_id         = var.folder_id
  labels            = var.labels
  billing_account   = var.billing_account
  activate_apis     = var.activate_apis
}

module "gke" {
  source = "./modules/gke"

  project_id                 = module.gcp.project_id
  project_id_prefix          = var.project_id_prefix
  master_authorized_networks = var.master_authorized_networks
  region                     = var.region
  zone                       = var.zone
}

module "ingress" {
  source = "./modules/ingress"

  project_id        = module.gcp.project_id
  project_id_prefix = var.project_id_prefix
  external_ip_name  = var.external_ip_name
  zone_name         = var.zone_name
  resource_group    = var.resource_group
}

module "atlantis" {
  source = "./modules/atlantis"

  project_id                 = module.gcp.project_id
  cluster_name               = module.gke.name
  master_authorized_networks = var.master_authorized_networks
}
