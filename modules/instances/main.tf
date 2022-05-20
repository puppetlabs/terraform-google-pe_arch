locals {
  metadata = merge({
    "ssh-keys"     = "${var.user}:${file(var.ssh_key)}"
    "VmDnsSetting" = "ZonalPreferred"
  }, var.metadata)
}

# PE server instance(s) depending on if a replica is provisioned or not
resource "google_compute_instance" "server" {
  name         = "pe-server-${var.id}-${count.index}"
  machine_type = var.primary_type
  count        = var.server_count
  zone         = element(var.zones, count.index)

  # Constructing an FQDN from GCP convention for Zonal DNS and storing it as
  # metadata so it is a property of the instance, making it easy to use later in
  # Bolt
  metadata = merge({
    "internalDNS"  = var.domain_name == null ? "pe-server-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal" : "pe-server-${var.id}-${count.index}.${var.domain_name}"
  }, local.metadata)

  labels = var.labels

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = var.primary_disk
      type  = "pd-ssd"
    }
  }

  # Configuration of instances requires external IP address but it doesn't
  # matter what they are so dynamic sourcing them from global pool is ok
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

# Reasons given for what is happening in each reason block are they same as
# those given for the MoM instances, from a pure "infrastructure" perspective
# all the components of a PE stack are very similar

# Instances to run PE PSQL
resource "google_compute_instance" "psql" {
  name         = "pe-psql-${var.id}-${count.index}"
  machine_type = var.database_type
  # count is used to effectively "no-op" this resource in the event that we
  # deploy any architecture other than xlarge
  count = var.database_count
  zone  = element(var.zones, count.index)

  metadata = merge({
    "internalDNS"  = var.domain_name == null ? "pe-psql-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal" : "pe-psql-${var.id}-${count.index}.${var.domain_name}"
  }, local.metadata)

  labels = var.labels

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = var.database_disk
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

# Instances to run as compilers
resource "google_compute_instance" "compiler" {
  name         = "pe-compiler-${var.id}-${count.index}"
  machine_type = var.compiler_type
  # count is used to effectively "no-op" this resource in the event that we
  # deploy the standard architecture
  count = var.compiler_count
  zone  = element(var.zones, count.index)

  metadata = merge({
    "internalDNS"  = var.domain_name == null ? "pe-compiler-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal" : "pe-compiler-${var.id}-${count.index}.${var.domain_name}"
  }, local.metadata)

  labels = var.labels

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = var.compiler_disk
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

resource "google_compute_instance" "node" {
  name         = "pe-node-${var.id}-${count.index}"
  machine_type = "n1-standard-1"
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
      size  = 25
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
