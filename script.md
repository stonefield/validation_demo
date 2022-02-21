# Start point

module "demo" {
  source = "./work"
  cwagent = {
    enable    = true
    os        = "amazon_linux"
    log_group = {
      cluster = "my-cluster"
      role    = "my-role"
    }
    #metrics_namespace = "my-asg"
    namespace = "my-asg"
  }
}

output "demo" {
  value = module.demo.attributes
}

# map

------------
variable "cwagent" {
  description = "CloudWatch agent specification"
  type = map(any)
}

output "attributes" {
  value = var.cwagent
}

------------

* Problem here is that all elements must be of same type.

comment log_group

* Terraform changes boolean to string. This happens with numbers as well.

* So, map is useless

uncomment log_group


# object

------------
variable "cwagent" {
  description = "CloudWatch agent specification"
  type = object({})
}

output "attributes" {
  value = var.cwagent
}

------------


* Any parameter is now gone, since object has no defined attributes


# object defined

------------
variable "cwagent" {
  description = "CloudWatch agent specification"
  type = object({
    enable = bool
    os = string
    log_group = object({
      cluster = string
      role    = string
      })
    metrics_namespace = string
  })
}

output "attributes" {
  value = var.cwagent
}

------------

* Works ok, but

# optional attributes

------------
terraform {
  experiments = [module_variable_optional_attrs]
}

variable "cwagent" {
  description = "CloudWatch agent specification"
  type = object({
    enable = bool
    log_group = object({
      cluster = string
      role    = string
      })
    metrics_namespace = optional(string)
  })
}

output "attributes" {
  value = var.cwagent
}

------------

Lets have a look at outputs here:

output "attributes" {
  value = var.cwagent.namespace
}

output "attributes" {
  value = var.cwagent["namespace"]
}

output "attributes" {
  value = lookup(var.cwagent, "namespace", "unknown")
}

output "attributes" {
  value = keys(var.cwagent)
}

Change comments:
    #metrics_namespace = "my-asg"
    namespace = "my-asg"

* Now it states that the required attribute `metrics_namespace` is missing


# unspecified type

------------
variable "cwagent" {
  description = "CloudWatch agent specification"
}

output "attributes" {
  value = var.cwagent
}

------------


* This is ok, but how do we ensure that the input is valid?

# unspecified type with keys validation

* Add validation module

------------

module "validation" {
  source   = "git@github.com:basefarm/terraform-aws-bf-utils//validation?ref=v0.2.1"
  module   = path.module
  assert_valid = {
    cwagent = {
      value = var.cwagent
      keys = "os,enable,log_group,metrics_namespace"
    }
  }
}


------------



# unspecified type with presence validation

* Add presence

------------
      presence = "enable,metrics_namespace"


------------


# validation with assert

* Add assertion

------------
  assert = [
    [can(regex("amazon_linux_2|ubuntu", var.cwagent.os)), "Operating system (os) must be amazon_linux_2 OR ubuntu."]
  ]

------------


# assign defaults

------------
variable "cwagent" {
  description = "CloudWatch agent specification"
  /*dynamic
    enable    = bool      # Enable CloudWatch
    os        = string    # Operating system
    dashboard = bool      # Enable Dashboard
    log_group = {         # Log group
      cluster = string    # Name of cluster or group
      role = string       # Role in cluster
    }
    metrics_namespace = string # Name of metric namespace for CloudWatch
  */
}

locals {
  cwagent = merge({
    dashboard = true
    os        = "amazon_linux_2"
    })
}


module "validation" {
  source = "git@github.com:basefarm/terraform-aws-bf-utils//validation?ref=v0.2.0"
  module = path.module
  assert_valid = {
    cwagent = {
      value    = local.cwagent
      keys     = "os,enable,log_group,metrics_namespace"
      presence = "enable,metrics_namespace,log_group"
    }
  }
  assert = [
    [can(regex("amazon_linux_2|ubuntu", local.cwagent.os)), "Operating system (os) must be amazon_linux_2 OR ubuntu."]
  ]
}


output "attributes" {
  value = var.cwagent
}

------------


* Run

  pre-commit run -a



## [Test heading](#fest_heading)



