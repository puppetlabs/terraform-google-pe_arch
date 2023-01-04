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
  default     = "~/.ssh/id_rsa.pub"
}
variable "zones" {
  description = "GCP zone that are within the defined GCP region that you wish to use"
  type        = list(string)
}
variable "node_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
  default     = 1
}
variable "instance_image" {
  description = "The disk image to use when deploying new cloud instances"
  type        = string
  default     = "almalinux-cloud/almalinux-8"
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
  default     = null
}
variable subnetwork_project {
  description = "Regional subnetwork project assigned to VPC network provisioned by the networking submodule"
  type        = string
  default     = null
}
variable "id" {
  description = "Randomly generated value used to produce unique names for everything to prevent collisions and visually link resources together"
  type        = string
}
variable "node_type" {
  description = "Instance type of compilers"
  type        = string
  default     = "n1-standard-1"
}
variable "node_disk" {
  description = "Instance disk size of compilers"
  type        = number
  default     = 20
}
variable "domain_name" {
  description = "Custom domain to use for internalDNS"
  type        = string
  default     = null
}