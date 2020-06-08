# Output Variables

output "google_compute_network_name" {
  description = "Google VPC Network Name"
  value       = "${google_compute_network.vpc-network.name}"
}
