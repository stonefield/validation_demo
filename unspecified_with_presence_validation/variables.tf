variable "cwagent" {
  description = "CloudWatch agent specification"
}

module "validation" {
  #source   = "git@github.com:basefarm/terraform-aws-bf-utils//validation?ref=v0.1.0"
  source = "../../../terraform-aws-bf-utils//validation"
  module   = path.module
  assert_valid = {
    map = {
      value = var.cwagent
      keys = "os,enable,log_group,metrics_namespace"
      presence = "enable,metrics_namespace"
    }
  }
}


output "attributes" {
  value = var.cwagent
}
