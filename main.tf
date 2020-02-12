provider "google" {
  project = var.project
  region  = var.region
}

# It is intended that multiple deployments can be launched easily without
# name colliding
resource "random_id" "deployment" {
  byte_length = 3
}

# Contain all the networking configuration in a module for readability
module "networking" {
  source = "./modules/networking"
  id     = random_id.deployment.hex
  allow  = var.firewall_allow
}

# Contain all the loadbalancer configuration in a module for readability
module "loadbalancer" {
  source     = "./modules/loadbalancer"
  id         = random_id.deployment.hex
  ports      = ["8140", "8142"]
  network    = module.networking.network_link
  subnetwork = module.networking.subnetwork_link
  region     = var.region
  zones      = var.zones
  instances  = module.instances.compilers
}

# Instance module called from a dynamic source dependent on deploying 
# architecture
module "instances" {
  source         = "./modules/instances"
  id             = random_id.deployment.hex
  network        = module.networking.network_link
  subnetwork     = module.networking.subnetwork_link
  zones          = var.zones
  user           = var.user
  ssh_key        = var.ssh_key
  compiler_count = var.compiler_count
  instance_image = var.instance_image
  project        = var.project
  architecture   = var.architecture
}