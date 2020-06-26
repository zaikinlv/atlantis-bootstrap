org_id            = "123..."                # GCP organization ID
zone_name         = "example.com"           # DNS zone name in Azure
resource_group    = "group_name"            # The resource group where the DNS Zone exists
project_id_prefix = "atlantis-test"         # Project prefix ID of the Atlantis project
project_name      = "Atlantis test"         # The name of the GCP project created for Atlantis resources
billing_account   = "111111-111111-111111"  # GCP billing account ID
folder_id         = "111111111111"          # The ID of a folder to host the Atlantis project
labels = {                                  # Labels to use on the project
  "label_key" = "label_name",
}
master_authorized_networks = [              # The list of CIDR blocks of master authorized networks. This will also be used for access to the Atlantis GUI
  {
    cidr_block   = "111.222.1.20/32"
    display_name = "firstname.lastname@example.com"
  },
]
