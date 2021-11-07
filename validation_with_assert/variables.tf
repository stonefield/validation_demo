variable "cwagent" {
  description = "CloudWatch agent specification"
}

module "validation" {
  #source   = "git@github.com:basefarm/terraform-aws-bf-utils//validation?ref=v0.2.0"
  source = "../../../terraform-aws-bf-utils//validation"
  module   = path.module
  assert_valid = {
    cwagent = {
      value = var.cwagent
      keys = "os,enable,log_group,metrics_namespace"
      presence = "enable,metrics_namespace"
    }
  }
  assert = [
    [can(regex("amazon_linux_2|ubuntu", var.cwagent.os)), "Operating system (os) must be amazon_linux_2 OR ubuntu."]
  ]
}


output "attributes" {
  value = var.cwagent
}
