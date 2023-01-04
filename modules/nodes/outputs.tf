# Output data that will be used by other submodules to build other parts of the
# stack to support defined architecture
output "nodes" {
  value       = google_compute_instance.node[*]
  description = "Depending on architecture, either the primary master or the group of compilers created by the module for use by other modules"
  sensitive   = true
}