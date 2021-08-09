# Output data that will be used by other submodules to build other parts of the
# stack to support defined architecture
output "network_link" {
  value       = try(google_compute_network.pe[0].self_link, null)
  description = "The link to the VPC network created so it can inform other resource what network they are attached to"
}

output "subnetwork_link" {
  value       = try(google_compute_subnetwork.pe_west[0].self_link, null)
  description = "The link to the created regional subnet so it can inform other resource what they are attached to"
}