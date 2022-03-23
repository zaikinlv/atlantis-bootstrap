module "atlantis-test" {
  #  source = "github-com/statisticsnorway/atlantis-bootstrap"
  source = "github.com/statisticsnorway/atlantis-bootstrap"

  org_id            = "123456789123"         # GCP organization ID
  zone_name         = "example.com"          # DNS zone name in Azure
  resource_group    = "rg_dns"               # The Azure AD resource group where the DNS Zone exists
  project_id_prefix = "atlantis-test"        # Project prefix ID of the Atlantis project
  project_name      = "Atlantis test"        # The name of the GCP project created for Atlantis resources
  billing_account   = "111111-222222-333333" # GCP billing account ID
  folder_id         = "123456789123"         # The ID of a folder to host the Atlantis project
  labels = {                                 # Labels to use on the project
    "billing_project" = "stratus",
  }
  master_authorized_networks = [ # The list of CIDR blocks of master authorized networks. This will also be used for access to the Atlantis GUI
    {
      cidr_block   = "111.222.333.444/32"
      display_name = "user.name@example.com"
    },
  ]
  azure_client_secret   = var.azure_client_secret
  azure_subscription_id = var.azure_subscription_id
  azure_tenant_id       = var.azure_tenant_id
  azure_client_id       = var.azure_client_id
  external_ip_name      = "atlantis-external-facing-ip"
}
