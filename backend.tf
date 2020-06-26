terraform {
  backend "gcs" {                     # See Terraform documentation for backend types
    bucket = "<bucket name>"
    prefix = "<prefix/folder name>"
  }
}
