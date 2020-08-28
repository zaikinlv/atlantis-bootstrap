terraform {
  backend "gcs" {
    bucket = "state-bucket"
    prefix = "test/atlantis"
  }
}
