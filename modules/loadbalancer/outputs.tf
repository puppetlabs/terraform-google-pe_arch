output "lb_dns_name" {
  value       = var.architecture == "standard" ? var.instances[0].metadata["internalDNS"] : try(google_compute_forwarding_rule.pe_compiler_lb[0].service_name, "") 
  description = "The IP of a new Pupept Enterprise compiler LB"
}