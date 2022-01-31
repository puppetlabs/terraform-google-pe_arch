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
variable "node_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
  default     = 0
}
variable "instance_image" {
  description = "The disk image to use when deploying new cloud instances"
  type        = string
  default     = "centos-cloud/centos-stream-8"
}
variable "stack_name" {
  description = "A name that'll help the user identify which instances are are part of a specific PE deployment"
  type        = string
  default     = "puppet-enterprise"
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
  description = "A map of labels that will be applied to the instances"
  type        = map
  default     = {}
}
variable "network" {
  description = "An optional network to use"
  type        = string
  default     = null
}
variable "subnetwork" {
  description = "An optional subnetwork to use"
  type        = string
  default     = null
}
variable "subnetwork_project" {
  description = "An optional subnetwork_project to use"
  type        = string
  default     = null
}
