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
  default     = 3

  validation {
    condition     = var.compiler_count >= 3
    error_message = "The compiler_count variable must be greater or equal to 3."
  }
}
variable "instance_image" {
  description = "The disk image to use when deploying new cloud instances"
  type        = string
  default     = "centos-cloud/centos-7"
}
variable "firewall_allow" {
  description = "List of permitted IP subnets, list most include the internal network and single addresses must be passed as a /32"
  type        = list(string)
  default     = []
}
variable "architecture" {
  description = "Which of the supported PE architectures modules to deploy xlarge, large, or standard"
  type        = string
  default     = "xlarge"
}
variable "destroy" {
  description = "Available to facilitate simplified destroy via Puppet Bolt, irrelevant outside specific use case"
  type        = bool
  default     = false
}