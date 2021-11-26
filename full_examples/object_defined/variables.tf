variable "cwagent" {
  description = "CloudWatch agent specification"
  type = object({
    enable = bool
    os     = string
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