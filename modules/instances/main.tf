# PE server instance(s) depending on if a replica is provisioned or not
resource "google_compute_instance" "server" {
  name         = "pe-server-${var.id}-${count.index}"
  machine_type = "e2-standard-4"
  count        = var.server_count
  zone         = element(var.zones, count.index)

  # Constructing an FQDN from GCP convention for Zonal DNS and storing it as
  # metadata so it is a property of the instance, making it easy to use later in
  # Bolt
  metadata = {
    "ssh-keys"     = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
    "internalDNS"  = "pe-server-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal"
  }

  labels = {
    "stack" = var.stack_name
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 50
      type  = "pd-ssd"
    }
  }

  # Configuration of instances requires external IP address but it doesn't
  # matter what they are so dynamic sourcing them from global pool is ok
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }
}

# Reasons given for what is happening in each reason block are they same as
# those given for the MoM instances, from a pure "infrastructure" perspective
# all the components of a PE stack are very similar

# Instances to run PE PSQL
resource "google_compute_instance" "psql" {
  name         = "pe-psql-${var.id}-${count.index}"
  machine_type = "e2-standard-8"
  # count is used to effectively "no-op" this resource in the event that we
  # deploy any architecture other than xlarge
  count = var.database_count
  zone  = element(var.zones, count.index)

  metadata = {
    "ssh-keys"     = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
    "internalDNS"  = "pe-psql-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal"
  }

  labels = {
    "stack" = var.stack_name
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 100
      type  = "pd-ssd"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }
}

# Instances to run as compilers
resource "google_compute_instance" "compiler" {
  name         = "pe-compiler-${var.id}-${count.index}"
  machine_type = "e2-standard-2"
  # count is used to effectively "no-op" this resource in the event that we
  # deploy the standard architecture
  count = var.compiler_count
  zone  = element(var.zones, count.index)

  metadata = {
    "ssh-keys"     = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
    "internalDNS"  = "pe-compiler-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal"
  }

  labels = {
    "stack" = var.stack_name
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 25
      type  = "pd-ssd"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }
}

resource "google_compute_instance" "node" {
  name         = "pe-node-${var.id}-${count.index}"
  machine_type = "n1-standard-1"
  # count is used to effectively "no-op" this resource in the event that we
  # deploy the standard architecture
  count = var.node_count
  zone  = element(var.zones, count.index)

  metadata = {
    "ssh-keys"     = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
    "internalDNS"  = "pe-node-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal"
  }

  labels = {
    "stack" = var.stack_name
  }

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 25
      type  = "pd-ssd"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }
}
