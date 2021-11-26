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

/*output "attributes" {
  value = var.cwagent.namespace
}*/

/*output "attributes" {
  value = var.cwagent["namespace"]
}*/

/*output "attributes" {
  value = lookup(var.cwagent, "namespace", "unknown")
}*/

/*output "attributes" {
  value = keys(var.cwagent)
}*/