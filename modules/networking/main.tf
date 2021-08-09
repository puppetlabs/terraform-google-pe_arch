locals {
  network_count = var.to_create ? 1 : 0
}
# To contain each PE deployment, a fresh VPC to deploy into
resource "google_compute_network" "pe" {
  count                   = local.network_count
  name                    = "pe-${var.id}"
  auto_create_subnetworks = false
}

# Manual creation of subnets works better when instances are dependent on their
# existence and allowing GCP to create them automatically creates a race
# condition
resource "google_compute_subnetwork" "pe_west" {
  count         = local.network_count
  name          = "pe-${var.id}"
  ip_cidr_range = "10.138.0.0/20"
  network       = google_compute_network.pe[0].self_link
}

# Instances should not be accessible by the open internet so a fresh VPC should
# be restricted to specific allowed subnets
resource "google_compute_firewall" "pe_default" {
  count         = local.network_count
  name          = "pe-default-${var.id}"
  network       = google_compute_network.pe[0].self_link
  priority      = 1000
  source_ranges = var.allow
  allow { protocol = "icmp" }
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
}