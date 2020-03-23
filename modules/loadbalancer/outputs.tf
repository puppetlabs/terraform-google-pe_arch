# Output data that will be used by other submodules to build other parts of the
# stack to support defined architecture
output "lb_dns_name" {
  value       = var.architecture == "standard" ? tolist(var.instances)[0].metadata["internalDNS"] : try(google_compute_forwarding_rule.pe_compiler_lb[0].service_name, "")
  description = "The DNS name of either the load balancer fronting the compiler pool or the primary master, depending on architecture"
}