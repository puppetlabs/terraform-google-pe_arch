# Zones list derived from where instances were previously deployed
locals {
  instance_zones = toset(nonsensitive(var.instances[*].zone))
  lb_count = var.has_lb ? 1 : 0
}

# Create an instance group per zone to attach that zone's compilers to
resource "google_compute_instance_group" "backend" {
  for_each  = var.has_lb ? local.instance_zones : []
  name      = "pe-compiler-${var.id}"
  instances = [for i in var.instances : i.self_link if i.zone == each.value]
  zone      = each.value
}

# Define a health check that'll indicate the health of a compiler node, very
# irritating that this is a 1:1 mapping of front end IP to port
resource "google_compute_health_check" "pe_compiler" {
  count = local.lb_count
  name  = "pe-compiler-${var.id}"

  tcp_health_check { port = var.ports[0] }
}

# The backend service that bundles together all the zonal instance groups
resource "google_compute_region_backend_service" "pe_compiler_lb" {
  count         = local.lb_count
  name          = "pe-compiler-lb-${var.id}"
  health_checks = [google_compute_health_check.pe_compiler[0].self_link]
  region        = var.region

  dynamic "backend" {
    for_each = local.instance_zones

    content { group = google_compute_instance_group.backend[backend.value].self_link }
  }
}

# Rule that defines what type of load balancing will be used and the network it
# will source an IP from
resource "google_compute_forwarding_rule" "pe_compiler_lb" {
  count                 = local.lb_count
  name                  = "pe-compiler-lb-${var.id}"
  service_label         = "puppet"
  load_balancing_scheme = "INTERNAL"
  ports                 = var.ports
  network               = var.network
  subnetwork            = var.subnetwork
  backend_service       = google_compute_region_backend_service.pe_compiler_lb[0].self_link
}