# The module makes repeated use of the try() function so requires a very recent
# release of Terraform 0.12
terraform {
  required_version = ">= 0.12.20"
  experiments      = [variable_validation]
}

provider "google" {
  project = var.project
  region  = var.region
}

# Retrieve list of zones to deploy to to prevent needing to know what they are
# for each region
data "google_compute_zones" "available" {
  count = var.destroy ? 0 : 1
  status = "UP"
}

# Short name for addressing the list of zones for the region
locals {
  zones   = try(data.google_compute_zones.available[0].names, ["a","b","c"])
  allowed = concat(["10.128.0.0/9"], var.firewall_allow)
}

# It is intended that multiple deployments can be launched easily without
# name collisions
resource "random_id" "deployment" {
  byte_length = 3
}

# Contain all the networking configuration in a module for readability
module "networking" {
  source = "./modules/networking"
  id     = random_id.deployment.hex
  allow  = local.allowed
}

# Contain all the loadbalancer configuration in a module for readability
module "loadbalancer" {
  source         = "./modules/loadbalancer"
  id             = random_id.deployment.hex
  ports          = ["8140", "8142"]
  network        = module.networking.network_link
  subnetwork     = module.networking.subnetwork_link
  region         = var.region
  zones          = local.zones
  instances      = module.instances.compilers
  architecture   = var.architecture
}

# Contain all the instances configuration in a module for readability
module "instances" {
  source         = "./modules/instances"
  id             = random_id.deployment.hex
  network        = module.networking.network_link
  subnetwork     = module.networking.subnetwork_link
  zones          = local.zones
  user           = var.user
  ssh_key        = var.ssh_key
  compiler_count = var.compiler_count
  node_count     = var.node_count
  instance_image = var.instance_image
  project        = var.project
  architecture   = var.architecture
}
