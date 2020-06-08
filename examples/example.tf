# Example Composition Module

### Terraform Configuration Parameters
terraform {
  backend "gcs" {
    prefix = "terraform/state"

    # The GCS Bucket name is handled by a variable.
    # Uncomment if you want to statically set this value.
    #bucket = "gcs_bucket_name"
  }
  required_version = "= 0.12.24"
  required_providers {
    google      = "= 2.14"
    google-beta = "= 2.14"
    random      = "~> 2.2"
  }
}



### Terraform Providers

provider "google" {
  project = "${var.google_project_base}-${random_id.project_id.hex}"

  scopes = [
    # Default scopes
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/devstorage.full_control",

    # Required for google_client_openid_userinfo
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

provider "google-beta" {
  project = "${var.google_project_base}-${random_id.project_id.hex}"
}

provider "random" {}



### Prerequisite Resources

resource "random_id" "project_id" {
  byte_length = 3
}



### Terraform Modules

module "project" {
  source  = "app.terraform.io/abitvolatile/project/gcp"
  version = "~> 1.0"

  google_project_name    = "${var.google_project_base}-${random_id.project_id.hex}"
  google_billing_account = var.google_billing_account
  google_org_id          = var.google_org_id
  skip_delete            = var.skip_delete
  metadata               = var.metadata
}


module "vpc-networking" {
  source = "../"

  google_project_name = "${var.google_project_base}-${random_id.project_id.hex}"
}
