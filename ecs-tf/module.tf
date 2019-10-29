terraform {
  backend "s3" {
    region = "eu-west-1"
    bucket = "test-state-bucket"
    key    = "apps/test"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.29"
}
