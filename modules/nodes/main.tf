terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.68.0"
    }
  }
}

data "google_compute_zones" "available" {
  status = "UP"
}

# Collect some repeated values used by each major component module into one to
# make them easier to update

# GCP region and project to operating within
provider "google" {
  project = var.project
}

locals {
  metadata = merge({
    "ssh-keys"     = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
  }, var.metadata)
}

resource "google_compute_instance" "node" {
  name         = "pe-node-${var.id}-${count.index}"
  machine_type = var.node_type
  # count is used to effectively "no-op" this resource in the event that we
  # deploy the standard architecture
  count = var.node_count
  zone  = element(var.zones, count.index)

  metadata = merge({
    "internalDNS"  = var.domain_name == null ? "pe-node-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal" : "pe-node-${var.id}-${count.index}.${var.domain_name}"
  }, local.metadata)

  labels = var.labels

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = var.node_disk
      type  = "pd-ssd"
    }
  }

  # If a subnetwork_project is specified, an external IP is not needed.
  network_interface {
    network            = var.network
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    dynamic "access_config" {
      for_each = var.subnetwork_project == null ? [1] : []
      content {}
    }
  }
}
