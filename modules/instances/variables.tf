# These are the variables required for the instances submodule to function
# properly and are duplicated highly from the main module but instead do not
# have any defaults set because this submodule should never by called from
# anything else expect the main module where values for all these variables will
# always be passed in
variable "user" {
  description = "Instance user name that will used for SSH operations"
  type        = string
}
variable "ssh_key" {
  description = "Location on disk of the SSH public key to be used for instance SSH access"
  type        = string
}
variable "zones" {
  description = "GCP zone that are within the defined GCP region that you wish to use"
  type        = list(string)
}
variable "compiler_count" {
  description = "The quantity of compilers that are deployed behind a load balancer and will be spread across defined zones"
  type        = number
}
variable "node_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
}
variable "server_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
}
variable "database_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
}
variable "instance_image" {
  description = "The disk image to use when deploying new cloud instances"
  type        = string
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
variable "project" {
  description = "Name of GCP project that will be used for housing require infrastructure"
  type        = string
}
variable network    {
  description = "VPC network provisioned by the networking submodule"
  type        = string
}
variable subnetwork {
  description = "Regional subnetwork assigned to VPC network provisioned by the networking submodule"
  type        = string
}
variable subnetwork_project {
  description = "Regional subnetwork project assigned to VPC network provisioned by the networking submodule"
  type        = string
}
variable "id" {
  description = "Randomly generated value used to produce unique names for everything to prevent collisions and visually link resources together"
  type        = string
}
variable "compiler_type" {
  description = "Instance type of compilers"
  type        = string
}
variable "primary_type" {
  description = "Instance type of primary and replica"
  type        = string
}
variable "database_type" {
  description = "Instance type of PuppetDB database and replica"
  type        = string
}
variable "compiler_disk" {
  description = "Instance disk size of compilers"
  type        = string
}
variable "primary_disk" {
  description = "Instance disk size of primary and replica"
  type        = string
}
variable "database_disk" {
  description = "Instance disk size of PuppetDB database and replica"
  type        = string
}
variable "domain_name" {
  description = "Custom domain to use for internalDNS"
  type        = string
  default     = null
}