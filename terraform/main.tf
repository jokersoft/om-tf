provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "credentials"
  profile                 = "default"
}

terraform {
  backend "s3" {
    region                  = "eu-central-1"
    bucket                  = "state-storage"
    key                     = "apps/om-tf"
    shared_credentials_file = "credentials"
  }
}
