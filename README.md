# google-pe_arch

IaC definitions for three of the supported Puppet Enterprise architectures for Google Cloud Platform

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with google-pe_arch](#setup)
    * [What google-pe_arch affects](#what-google-pe_arch-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with google-pe_arch](#beginning-with-google-pe_arch)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This Terraform module implements as code the infrastructure required to deploy three permutations of the [supported](https://puppet.com/docs/pe/latest/choosing_an_architecture.html) Puppet Enterprise architectures: Standard, Large, and Extra Large with a failover replica on Google Cloud Platform. While this module can function independently, it is primarily developed as a component of [puppetlabs/autope](https://github.com/puppetlabs/puppetlabs-autope) to facilitate the end-to-end deployment of fully functional stacks of Puppet Enterprise for evaluation or with additional guidance, production. It sets up native GCP networks and load balancers specifically for containing and managing access to the deployment but avoids a dependence on cloud provided SQL services since Puppet Enterprise has its own facilities for managing and automating PostgreSQL.

## Setup

### What google-pe_arch affects

Types of things you'll be paying your cloud provider for

* Instances of various sizes
* Load balancers
* Networks

### Setup Requirements

* [GCP Cloud SDK Intalled](https://cloud.google.com/sdk/docs/quickstarts)
* [GCP Application Default Credentials](https://cloud.google.com/sdk/gcloud/reference/auth/application-default/)
* [Git Installed](https://git-scm.com/downloads)
* [Terraform (>= 0.12.20) Installed](https://www.terraform.io/downloads.html)

### Beginning with google-pe_arch

1. Clone this repository
    * `git clone https://github.com/puppetlabs/terraform-google-pe_arch.git && cd terraform-google-pe_arch`
2. Install module dependencies: `terraform init`
3. Initiate plan for the default Extra Large with replica
    * `terraform apply -auto-approve -var "project=example.com" -var "user=john.doe" -var "firewall_allow=[ \"0.0.0.0/0\" ]"`
4. Approximately 2 minutes later you'll have 7 VMs live and wired into an appropriate load balancer

## Usage

### Example: deploy standard architecture with a more restrictive network

This will give you the absolute minimum needed for installing Puppet Enterprise, a single VM plus a specific network for it to reside within and limited to a specific network that have access to the new infrastructure (note: don't forget to include the local network, if you use [puppetlabs/autope](https://github.com/puppetlabs/puppetlabs-autope/blob/master/Boltdir/site-modules/autope/plans/init.pp#L19) then this will be done automatically)

`terraform apply -auto-approve -var "project=example.com" -var "user=john.doe" -var "firewall_allow=[ \"10.128.0.0/9\", \"192.69.65.0/24\" ]" -var architecture=standard`

### Example: destroy stack

The number of options required are reduced when destroying a stack

`terraform destroy -auto-approve -var "project=example.com" -var "user=john.doe"`

## Limitations

Currently limited to CentOS and VM disk sizes are not configurable
