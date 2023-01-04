variable "project" {
  description = "Name of GCP project that will be used for housing require infrastructure"
  type        = string
}
variable "user" {
  description = "Instance user name that will used for SSH operations"
  type        = string
}
variable "ssh_key" {
  description = "Location on disk of the SSH public key to be used for instance SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "region" {
  description = "GCP region that'll be targeted for infrastructure deployment"
  type        = string
  default     = "us-west1"
}
variable "compiler_count" {
  description = "The quantity of compilers that are deployed behind a load balancer and will be spread across defined zones"
  type        = number
  default     = 1
}
variable "instance_image" {
  description = "The disk image to use when deploying new cloud instances"
  type        = string
  default     = "almalinux-cloud/almalinux-8"
}
variable "firewall_allow" {
  description = "List of permitted IP subnets, list most include the internal network and single addresses must be passed as a /32"
  type        = list(string)
  default     = []
}
variable "architecture" {
  description = "Which of the supported PE architectures modules to deploy xlarge, large, or standard"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "large", "xlarge"], var.architecture)
    error_message = "Architecture selection must match one of standard, large, or xlarge."
  }
}
variable "replica" {
  description = "To deploy instances required for the provisioning of a server replica"
  type        = bool
  default     = false
}
variable "destroy" {
  description = "Available to facilitate simplified destroy via Puppet Bolt, irrelevant outside specific use case"
  type        = bool
  default     = false
}
variable "cluster_profile" {
  description = "Which cluster profile to use for defining provisioned instance sizes"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["production", "development", "user"], var.cluster_profile)
    error_message = "The cluster profile selection must match one of production, development, or user."
  }
}
variable "labels" {
  description = "A list of labels that will be applied to virtual instances"
  type        = map
  default     = {}
}
variable "metadata" {
  description = "A map of user supplied metadata that will be applied to virtual instances"
  type        = map
  default     = {}
}
variable "subnet" {
  description = "An optional subnet to use"
  type        = string
  default     = null
}
variable "subnet_project" {
  description = "An optional subnet_project to use"
  type        = string
  default     = null
}
variable "lb_ip_mode" {
  description = "Designate if a public or private IP address is assigned to load balancer"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.lb_ip_mode)
    error_message = "The provisioned load balancer can only have a public or private IP address assigned."
  }
}
variable "disable_lb" {
  description = "Disable load balancer creation for all architectures if you desire manually provisioning your own"
  type        = bool
  default     = false
}
variable "domain_name" {
  description = "Custom domain to use for internalDNS"
  type        = string
  default     = null
}