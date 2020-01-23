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
  source = "../modules/networking"
  id     = random_id.deployment.hex
  allow  = var.firewall_allow
}

# Contain all the loadbalancer configuration in a module for readability
module "loadbalancer" {
  source     = "../modules/loadbalancer"
  id         = random_id.deployment.hex
  ports      = ["8140", "8142"]
  network    = module.networking.network_link
  subnetwork = module.networking.subnetwork_link
  region     = var.region
  zones      = var.zones
  instances  = google_compute_instance.compiler[*]
}

# Instances to run PE MOM
resource "google_compute_instance" "master" {
  name         = "pe-master-${random_id.deployment.hex}-${count.index}"
  machine_type = "e2-standard-4"
  count        = 1
  zone         = element(var.zones, count.index)

  # Old style internal DNS easiest until Bolt inventory dynamic
  metadata = {
    "sshKeys" = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 50
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = module.networking.network_link
    subnetwork = module.networking.subnetwork_link
    access_config { }
  }

  # Using remote-execs on each instance deployemnt to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  provisioner "remote-exec" {
    connection {
      host = self.network_interface[0].access_config[0].nat_ip
      type = "ssh"
      user = var.user
    }
    inline = ["# Connected"]
  }
}

# Instances to run a compilers
resource "google_compute_instance" "compiler" {
  name         = "pe-compiler-${random_id.deployment.hex}-${count.index}"
  machine_type = "e2-standard-2"
  count        = var.compiler_count
  zone         = element(var.zones, count.index)

  # Old style internal DNS easiest until Bolt inventory dynamic
  metadata = {
    "sshKeys" = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 15
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = module.networking.network_link
    subnetwork = module.networking.subnetwork_link
    access_config { }
  }

  # Using remote-execs on each instance deployemnt to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  provisioner "remote-exec" {
    connection {
      host = self.network_interface[0].access_config[0].nat_ip
      type = "ssh"
      user = var.user
    }
    inline = ["# Connected"]
  }
}