#-------------------------------------#
# Create a static external IP address #
#-------------------------------------#

module "address-fe" {
  source        = "terraform-google-modules/address/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  names         = [var.external_ip_name]
  global        = true
  region        = var.region
  address_type  = "EXTERNAL"
  prefix_length = 0
  purpose       = "GCE_ENDPOINT"
}

#-------------------------------------------------------#
# Create a DNS record for google_compute_global_address #
#-------------------------------------------------------#
resource "azurerm_dns_a_record" "cluster" {
  name                = var.project_id_prefix
  zone_name           = var.zone_name
  resource_group_name = var.resource_group
  ttl                 = "300"
  records             = module.address-fe.addresses
}
