# Terraform setup stuff, required providers, where they are sourced from, and
# the provider's configuration requirements.
terraform {
  required_providers {
    hiera5 = {
      source  = "sbitio/hiera5"
      version = "0.2.7"
    }
    google = {
      source  = "hashicorp/google"
      version = "3.68.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

# Sets the variables that'll be interpolated to determine where variables are
# located in the hierarchy
provider "hiera5" {
  scope = {
    architecture = var.architecture
    replica      = var.replica
  }
}

# GCP region and project to operating within
provider "google" {
  project = var.project
  region  = var.region
}

# hiera lookps
data "hiera5" "server_count" {
  key = "server_count"
}
data "hiera5" "database_count" {
  key = "database_count"
}
data "hiera5_bool" "has_compilers" {
  key = "has_compilers"
}

# Retrieve list of zones to deploy to prevent needing to know what they are for
# each region. Use count to trigger a no-op when Bolt runs a destroy plan.
data "google_compute_zones" "available" {
  count  = var.destroy ? 0 : 1
  status = "UP"
}

# It is intended that multiple deployments can be launched easily without
# name collisions
resource "random_id" "deployment" {
  byte_length = 3
}

# Collect some repeated values used by each major component module into one to
# make them easier to update
locals {
  zones          = try(data.google_compute_zones.available[0].names, ["a", "b", "c"])
  allowed        = concat(["10.128.0.0/9", "35.191.0.0/16", "130.211.0.0/22"], var.firewall_allow)
  compiler_count = data.hiera5_bool.has_compilers.value ? var.compiler_count : 0
  id             = random_id.deployment.hex
  network        = module.networking.network_link
  subnetwork     = module.networking.subnetwork_link
  has_lb         = data.hiera5_bool.has_compilers.value ? true : false
  labels         = merge(var.labels, { "stack" = var.stack_name })
}

# Contain all the networking configuration in a module for readability
module "networking" {
  source = "./modules/networking"
  id     = local.id
  allow  = local.allowed
}

# Contain all the loadbalancer configuration in a module for readability
module "loadbalancer" {
  source       = "./modules/loadbalancer"
  id           = local.id
  ports        = ["8140", "8142"]
  network      = local.network
  subnetwork   = local.subnetwork
  region       = var.region
  instances    = module.instances.compilers
  has_lb       = local.has_lb
}

# Contain all the instances configuration in a module for readability
module "instances" {
  source         = "./modules/instances"
  id             = local.id
  network        = local.network
  subnetwork     = local.subnetwork
  zones          = local.zones
  user           = var.user
  ssh_key        = var.ssh_key
  compiler_count = local.compiler_count
  node_count     = var.node_count
  instance_image = var.instance_image
  labels         = local.labels
  project        = var.project
  server_count   = data.hiera5.server_count.value
  database_count = data.hiera5.database_count.value
}
