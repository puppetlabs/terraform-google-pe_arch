# Instances to run PE MOM
resource "google_compute_instance" "master" {
  name         = "pe-master-${var.id}-${count.index}"
  machine_type = "e2-standard-4"
  count        = var.architecture == "xlarge" ? 2 : 1
  zone         = element(var.zones, count.index)

  # Old style internal DNS easiest until Bolt inventory dynamic
  metadata = {
    "sshKeys" = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
    "internalDNS" = "pe-master-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal"
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 50
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    access_config { }
  }

  # Using remote-execs on each instance deployment to ensure things are really
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

# Instances to run PE PSQL
resource "google_compute_instance" "psql" {
  name         = "pe-psql-${var.id}-${count.index}"
  machine_type = "e2-standard-8"
  count        = var.architecture == "xlarge" ? 2 : 0
  zone         = element(var.zones, count.index)

  # Old style internal DNS easiest until Bolt inventory dynamic
  metadata = {
    "sshKeys" = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
    "internalDNS" = "pe-psql-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal"
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 100
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    access_config { }
  }

  # Using remote-execs on each instance deployment to ensure things are really
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
  name         = "pe-compiler-${var.id}-${count.index}"
  machine_type = "e2-standard-2"
  count        = var.compiler_count
  zone         = element(var.zones, count.index)

  # Old style internal DNS easiest until Bolt inventory dynamic
  metadata = {
    "sshKeys" = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
    "internalDNS" = "pe-compiler-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal"
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 15
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = var.network
    subnetwork = var.subnetwork
    access_config { }
  }

  # Using remote-execs on each instance deployment to ensure things are really
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