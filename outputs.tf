# Output data used by Bolt to do further work, doing this allows for a clean and
# abstracted interface between cloud provider implementations
output "metadata" {
  value = {
    "network" : coalesce(module.networking.network_link, try(data.google_compute_subnetwork.existing[0].network, null)),
    "subnet"  : coalesce(module.networking.subnetwork_link, try(data.google_compute_subnetwork.existing[0].self_link, null)),
    "id"      : local.id,
    "zones"   : local.zones
  }
}
output "console" {
  value       = module.instances.console
  description = "This will by the external IP address assigned to the Puppet Enterprise console"
}
output "pool" {
  value       = module.loadbalancer.lb_dns_name
  description = "The GCP internal network FQDN of the Puppet Enterprise compiler pool"
  sensitive   = true
}
