variable "cwagent" {
  description = "CloudWatch agent specification"
}

module "validation" {
  source = "git@github.com:basefarm/terraform-aws-bf-utils//validation?ref=v0.2.1"
  module = path.module
  assert_valid = {
    cwagent = {
      value = var.cwagent
      keys  = "os,enable,log_group,metrics_namespace"
    }
  }
}


output "attributes" {
  value = var.cwagent
}
