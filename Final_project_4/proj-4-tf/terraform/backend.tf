terraform {
  backend "s3" {
    bucket = "anpod07-tf-statefile"
    key    = "proj4/terraform.tfstate"
    region = "eu-central-1"
    encrypt=true
  }
}

