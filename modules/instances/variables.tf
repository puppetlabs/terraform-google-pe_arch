variable "id" {
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
variable "zones" {
  description = "GCP zone that are within the defined GCP region that you wish to use"
  type        = list(string)
  default     = [ "us-west1-a", "us-west1-b", "us-west1-c" ]
}
variable "compiler_count" {
  description = "The quantity of compilers that are deployed behind a load balancer and will be spread across defined zones"
  type        = number
  default     = 3
}
variable "instance_image" {
  description = "The disk image to use when deploying new cloud instances"
  type        = string
  default     = "centos-cloud/centos-7"
}
variable network    {}    
variable subnetwork {} 
variable project {} 
variable architecture {} 