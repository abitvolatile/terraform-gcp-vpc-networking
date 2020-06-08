### Terraform Resources

resource "google_project_service" "compute" {
  project            = var.google_project_name
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}


resource "google_compute_network" "vpc-network" {
  depends_on = [
    google_project_service.compute
  ]

  project                 = var.google_project_name
  name                    = "vpc-network"
  auto_create_subnetworks = false
}
